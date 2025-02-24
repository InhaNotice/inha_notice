/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-20
 */
import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/notice_board/base_notice_board.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/bookmark/bookmark_manager.dart';
import 'package:inha_notice/widgets/buttons/rounded_toggle_button.dart';
import 'package:inha_notice/widgets/notice/notice_list_tile.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_app_bar.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_snack_bar.dart';
import 'package:logger/logger.dart';

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

  /// **북마크된 공지사항 로드 (읽은 공지사항 반영)**
  Future<void> loadNotices() async {
    setState(() {
      isLoading = true;
    });
    final notices = await BookmarkManager.getAllBookmarks();
    originalBookmarkedNotices = List.from(notices);
    bookmarkedNotices = List.from(notices)
      ..sort((a, b) => b['date'].compareTo(a['date']));
    setState(() {
      isLoading = false;
    });
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
      appBar: const ThemedAppBar(
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
          RoundedToggleButton(
              text: '최신순',
              option: 'NEWEST',
              isSelected: orderNewest,
              onTap: toggleOption),
          const SizedBox(width: 10),
          RoundedToggleButton(
              text: '과거순',
              option: 'OLDEST',
              isSelected: orderOldest,
              onTap: toggleOption),
          const SizedBox(width: 10),
          RoundedToggleButton(
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
              await BookmarkManager.clearAllBookmarks();
              setState(() {
                if (bookmarkedNotices.isEmpty && mounted) {
                  ThemedSnackBar.warnSnackBar(context, '삭제할 북마크가 없습니다!');
                  return;
                }
                bookmarkedNotices.clear();
                if (mounted) {
                  ThemedSnackBar.succeedSnackBar(context, '모두 삭제되었습니다.');
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
          ? const Center(child: CircularProgressIndicator())
          : bookmarkedNotices.isEmpty
              ? Center(
                  child: Text(
                    "저장된 북마크가 없습니다.",
                    style: TextStyle(
                      fontFamily: Font.kDefaultFont,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).textTheme.bodyMedium?.color ??
                          Theme.of(context).defaultColor,
                    ),
                  ),
                )
              : ListView.builder(
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
    );
  }

  // 북마크 페이지는 페이지네이션을 정의하지 않음
  @override
  Widget buildFooter() {
    return const SizedBox();
  }
}
