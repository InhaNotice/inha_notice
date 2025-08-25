/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-25
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/constants/page_constants.dart';
import 'package:inha_notice/screens/notice_board/base_notice_board.dart';
import 'package:inha_notice/screens/notice_board/notice_list_tile.dart';
import 'package:inha_notice/services/relative_style_scraper/base_relative_style_notice_scraper.dart';
import 'package:inha_notice/services/relative_style_scraper/library_scraper.dart';
import 'package:inha_notice/widgets/buttons/rounded_toggle_button.dart';
import 'package:inha_notice/widgets/loading_indicators/blue_loading_indicator.dart';
import 'package:inha_notice/widgets/pagination/relative_style_pagination.dart';
import 'package:inha_notice/widgets/refresh_headers/notice_refresh_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// **RelativeStyleNoticeBoard**
/// 이 클래스는 RelativeStyle의 공지사항을 제공하는 클래스입니다.
///
/// ### 주요 기능:
/// - 지원 공지: 정석
class RelativeStyleNoticeBoard extends BaseNoticeBoard {
  final String noticeType;

  const RelativeStyleNoticeBoard({super.key, required this.noticeType});

  @override
  State<RelativeStyleNoticeBoard> createState() =>
      _RelativeStyleNoticeBoardState();
}

class _RelativeStyleNoticeBoardState
    extends BaseNoticeBoardState<RelativeStyleNoticeBoard> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late BaseRelativeStyleNoticeScraper _relativeStyleNoticeScraper;
  bool _isHeadlineSelected = false;
  bool _isGeneralSelected = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  /// **Refresh 컨트롤러(새로운 공지 불러옴)**
  void _onRefresh() async {
    await loadNotices(PageConstants.kInitialRelativePage);
    _refreshController.refreshCompleted();
  }

  Future<void> initializeScraper() async {
    if (widget.noticeType == 'LIBRARY') {
      _relativeStyleNoticeScraper = LibraryScraper();
    }
  }

  @override
  Future<void> initialize() async {
    try {
      await initializeScraper();
      await loadNotices(PageConstants.kInitialRelativePage); // 공지사항 로드
    } catch (e) {
      // 에러 처리
      debugPrint('Initialization error: $e');
    }
  }

  @override
  void toggleOption(String option) {
    setState(() {
      if (option == 'headline') {
        _isHeadlineSelected = true;
        _isGeneralSelected = false;
      } else if (option == 'general') {
        _isHeadlineSelected = false;
        _isGeneralSelected = true;
      }
    });
  }

  /// **RelativeStyle의 공지를 불러옴**
  Future<void> loadNotices(int offset,
      [String? searchColumn, String? searchWord]) async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedNotices =
          await _relativeStyleNoticeScraper.fetchNotices(offset);
      if (!mounted) return;
      setState(() {
        notices = fetchedNotices;
        if (offset == PageConstants.kInitialRelativePage && pages.isEmpty) {
          pages = List<Map<String, dynamic>>.from(notices['pages']);
        }
        // offset을 통한 현재 페이지로 변환
        currentPage = (offset ~/ 10) + 1;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // 중요공지가 있을때만 토글 버튼이 생성됩니다.
          if (notices['headline'].isNotEmpty)
            // 중요공지 버튼
            RoundedToggleButton(
                text: '중요',
                option: 'headline',
                isSelected: _isHeadlineSelected,
                onTap: toggleOption),
          const SizedBox(width: 10),
          // 일반공지 버튼
          RoundedToggleButton(
              text: '일반',
              option: 'general',
              isSelected: _isGeneralSelected,
              onTap: toggleOption),
        ],
      ),
    );
  }

  @override
  Widget buildMain() {
    return Expanded(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: isLoading
            ? const Center(child: BlueLoadingIndicator())
            : SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                enablePullDown: true,
                header: const NoticeRefreshHeader(),
                child: ListView.builder(
                  // 중요 공지와 일반 공지 중 하나만 선택이 가능합니다.
                  itemCount: _isHeadlineSelected
                      ? notices['headline'].length
                      : notices['general'].length,
                  itemBuilder: (context, index) {
                    final notice = _isHeadlineSelected
                        ? notices['headline'][index]
                        : notices['general'][index];
                    // 공지 리스트에서 공지가 읽음 상태인지 확인하고, NoticeListTile에 그 상태를 전달합니다.
                    final isRead = isNoticeRead(notice['id'].toString());
                    final isBookmarked =
                        isNoticeBookmarked(notice['id'].toString());
                    return NoticeListTile(
                      notice: notice,
                      isRead: isRead,
                      isBookmarked: isBookmarked,
                      markNoticeAsRead: markNoticeAsRead,
                      // 읽음 처리 함수 전달
                      toggleBookmark: toggleBookmark,
                    );
                  },
                ),
              ),
      ),
    );
  }

  @override
  Widget buildFooter() {
    if (pages.isEmpty || _isHeadlineSelected) return const SizedBox();
    return RelativeStylePagination(
      pageType: 'LIBRARY',
      pages: pages,
      currentPage: currentPage,
      loadNotices: loadNotices,
    );
  }
}
