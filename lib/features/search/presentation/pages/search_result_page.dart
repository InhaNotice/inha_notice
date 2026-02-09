/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-18
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/constants/page_constants.dart';
import 'package:inha_notice/core/constants/string_constants.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/core/presentation/widgets/notice_tile_widget.dart';
import 'package:inha_notice/core/presentation/widgets/rounded_toggle_widget.dart';
import 'package:inha_notice/features/notice/presentation/pages/base_notice_board_page.dart';
import 'package:inha_notice/features/search/data/datasources/search_scraper.dart';
import 'package:inha_notice/screens/pagination/relative_style_pagination.dart';
import 'package:inha_notice/widgets/refresh_headers/notice_refresh_header.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// **SearchResultPage**
/// 이 클래스는 사용자 입력에 따른 검색 결과를 불러오는 클래스입니다.
class SearchResultPage extends BaseNoticeBoardPage {
  final String query;
  final bool isSearchResultPage;

  const SearchResultPage(
      {super.key, required this.query, required this.isSearchResultPage});

  @override
  State<SearchResultPage> createState() => _LibraryNoticeBoardState();
}

class _LibraryNoticeBoardState
    extends BaseNoticeBoardPageState<SearchResultPage> {
  final logger = Logger();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  SearchScraper searchScraper = SearchScraper();
  bool showRank = false;
  bool showDate = true;

  String sortedType = StringConstants.kDefaultSortedType;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  /// **Refresh 컨트롤러(새로운 공지 불러옴)**
  void _onRefresh() async {
    await loadNotices(PageConstants.kInitialAbsolutePage);
    _refreshController.refreshCompleted();
  }

  Future<void> initialize() async {
    try {
      await loadNotices(PageConstants.kInitialRelativePage);
    } catch (e) {
      logger.e('${runtimeType.toString()} - initialize() 오류: $e');
    }
  }

  void toggleOption(String option) {
    setState(() {
      if (option == 'RANK') {
        showRank = true;
        showDate = false;
      } else {
        showRank = false;
        showDate = true;
      }
      sortedType = option;
      loadNotices(PageConstants.kInitialRelativePage);
    });
  }

  Future<void> loadNotices(int startCount,
      [String? searchColumn, String? searchWord]) async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedNotices = await searchScraper.fetchNotices(
          widget.query, startCount, sortedType);
      if (!mounted) return;
      setState(() {
        notices = fetchedNotices;
        // 최초 공지사항 로드시 페이지 리스트 초기화
        if (startCount == PageConstants.kInitialRelativePage &&
            pages['pageMetas'].isEmpty) {
          pages = Pages.from(notices['pages']);
        }
        // offset을 통한 현재 페이지로 변환
        currentPage = (startCount ~/ 10) + 1;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      logger.e('${runtimeType.toString()} - loadNotices() 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSearchResultPage) {
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
    return Scaffold(
      appBar: CommonAppBarWidget(
        title: '검색 결과: ${widget.query}',
        titleSize: 17,
        isCenter: true,
      ),
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
              text: '정확도순',
              option: 'RANK',
              isSelected: showRank,
              onTap: toggleOption),
          const SizedBox(width: 10),
          RoundedToggleWidget(
              text: '최신순',
              option: 'DATE',
              isSelected: showDate,
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
            ? const Center(child: CircularProgressIndicator())
            : SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                enablePullDown: true,
                header: const NoticeRefreshHeader(),
                child: ListView.builder(
                  itemCount: notices['general'].length,
                  itemBuilder: (context, index) {
                    final notice = notices['general'][index];
                    final isRead = isNoticeRead(notice['id'].toString());
                    final isBookmarked =
                        isNoticeBookmarked(notice['id'].toString());
                    return NoticeTileWidget(
                      notice: NoticeTileModel.fromMap(notice),
                      isRead: isRead,
                      isBookmarked: isBookmarked,
                      markNoticeAsRead: markNoticeAsRead,
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
    // 중요공지 옵션일 경우 페이지 버튼을 숨기기
    if (pages['pageMetas'].isEmpty) return const SizedBox();

    // SearchResultPage가 아닌 경우 padding을 추가하지 않음
    if (!widget.isSearchResultPage) {
      return RelativeStylePagination(
        pageType: 'SEARCH',
        pages: pages,
        currentPage: currentPage,
        loadNotices: loadNotices,
      );
    }

    // SearchResultPage인 경우 padding을 추가함
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: RelativeStylePagination(
        pageType: 'SEARCH',
        pages: pages,
        currentPage: currentPage,
        loadNotices: loadNotices,
      ),
    );
  }
}
