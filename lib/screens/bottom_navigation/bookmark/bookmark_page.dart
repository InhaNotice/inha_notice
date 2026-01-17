/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/core/presentation/widgets/blue_loading_indicator_widget.dart';
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/core/presentation/widgets/rounded_toggle_widget.dart';
import 'package:inha_notice/screens/notice_board/base_notice_board.dart';
import 'package:inha_notice/screens/notice_board/notice_list_tile.dart';
import 'package:inha_notice/utils/bookmark/bookmark_manager.dart';
import 'package:inha_notice/widgets/refresh_headers/bookmark_refresh_header.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// **BookmarkPage**
///
/// 이 클래스는 북마크 된 공지사항을 한 곳에서 관리 가능하도록 제공하는 클래스입니다.
/// 사용자는 모든 북마크 된 공지사항을 관리할 수 있습니다.
///
/// ### 주요 기능:
/// - 북마크 관리(삭제)
/// - 공지사항 정렬 옵션 제공(북마크된 순서, 이름순, 날짜순)
class BookmarkPage extends BaseNoticeBoard {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends BaseNoticeBoardState<BookmarkPage> {
  final logger = Logger();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // 정렬 옵션: orderName, orderNewest, orderOldest
  bool orderNewest = true; // 최신순 기본값
  bool orderOldest = false;
  bool orderName = false;

  /// 정렬 전 원본 북마크된 공지사항을 저장하고 관리하는 리스트
  List<Map<String, dynamic>> originalBookmarkedNotices = [];

  /// 정렬 후 북마크된 공지사항을 저장하고 관리하는 리스트(실제 출력을 담당)
  List<Map<String, dynamic>> bookmarkedNotices = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Future<void> initialize() async {
    try {
      await loadNotices();
    } catch (e) {
      logger.e('Initialization error: $e');
    }
  }

  /// **Refresh 컨트롤러(북마크를 다시 불러옴)**
  void _onRefresh() async {
    setState(() {
      orderNewest = true;
      orderOldest = false;
      orderName = false;
    });
    await loadNotices();
    _refreshController.refreshCompleted();
  }

  /// **북마크된 공지사항 로드 (읽은 공지사항 반영)**
  Future<void> loadNotices() async {
    setState(() {
      isLoading = true;
    });
    final notices = await BookmarkManager.getAllBookmarks();
    originalBookmarkedNotices = List.from(notices);
    bookmarkedNotices = List.from(notices);
    _sortNoticesByCurrentOption();
    setState(() {
      isLoading = false;
    });
  }

  /// **현재 정렬 옵션에 따른 분류**
  void _sortNoticesByCurrentOption() {
    if (orderNewest) {
      bookmarkedNotices.sort((a, b) => b['date'].compareTo(a['date']));
    } else if (orderOldest) {
      bookmarkedNotices.sort((a, b) => a['date'].compareTo(b['date']));
    } else if (orderName) {
      bookmarkedNotices.sort((a, b) => a['title'].compareTo(b['title']));
    }
  }

  /// **북마크 정렬 옵션 변경**
  @override
  void toggleOption(String option) {
    setState(() {
      if (option == 'NEWEST') {
        orderName = false;
        orderNewest = true;
        orderOldest = false;
        bookmarkedNotices.sort((a, b) => b['date'].compareTo(a['date']));
      } else if (option == 'OLDEST') {
        orderName = false;
        orderNewest = false;
        orderOldest = true;
        bookmarkedNotices.sort((a, b) => a['date'].compareTo(b['date']));
      } else {
        orderName = true;
        orderNewest = false;
        orderOldest = false;
        bookmarkedNotices.sort((a, b) => a['title'].compareTo(b['title']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBarWidget(
        title: '북마크',
        titleSize: 20,
        isCenter: false,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),
          buildMain(),
          buildFooter(),
        ],
      ),
    );
  }

  @override
  Widget buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RoundedToggleWidget(
              text: '최신순',
              option: 'NEWEST',
              isSelected: orderNewest,
              onTap: toggleOption),
          const SizedBox(width: 10),
          RoundedToggleWidget(
              text: '과거순',
              option: 'OLDEST',
              isSelected: orderOldest,
              onTap: toggleOption),
          const SizedBox(width: 10),
          RoundedToggleWidget(
            text: '이름순',
            option: 'NAME',
            isSelected: orderName,
            onTap: toggleOption,
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.delete_forever_outlined,
              color: Theme.of(context).iconTheme.color,
              size: 25,
            ),
            onPressed: () async {
              if (mounted && bookmarkedNotices.isEmpty) {
                AppSnackBar.warn(context, '삭제할 북마크가 없어요.');
                return;
              }
              await BookmarkManager.clearAllBookmarks();
              setState(() {
                bookmarkedNotices.clear();
                if (mounted) {
                  AppSnackBar.success(context, '모두 삭제하였어요.');
                }
              });
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildMain() {
    return Expanded(
      child: isLoading
          ? const Center(child: BlueLoadingIndicatorWidget())
          : bookmarkedNotices.isEmpty
              ? Center(
                  child: Text(
                    "저장된 북마크가 없어요.",
                    style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).textTheme.bodyMedium?.color ??
                          Theme.of(context).defaultThemedTextColor,
                    ),
                  ),
                )
              : SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  enablePullDown: true,
                  header: const BookmarkRefreshHeader(),
                  child: ListView.builder(
                    itemCount: bookmarkedNotices.length,
                    itemBuilder: (context, index) {
                      final notice = bookmarkedNotices[index];
                      final isRead = isNoticeRead(notice['id'].toString());
                      final isBookmarked =
                          isNoticeBookmarked(notice['id'].toString());
                      return NoticeListTile(
                        notice: notice,
                        isRead: isRead,
                        isBookmarked: isBookmarked,
                        markNoticeAsRead: markNoticeAsRead,
                        toggleBookmark: toggleBookmark,
                      );
                    },
                  ),
                ),
    );
  }

  // 북마크 페이지는 페이지네이션을 정의하지 않음
  @override
  Widget buildFooter() {
    return const SizedBox();
  }
}
