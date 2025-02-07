import 'package:flutter/material.dart';
import 'package:inha_notice/constants/page_constants.dart';
import 'package:inha_notice/screens/notice_board/base_notice_board.dart';
import 'package:inha_notice/services/relative_style_scraper/base_relative_style_notice_scraper.dart';
import 'package:inha_notice/services/relative_style_scraper/library_scraper.dart';
import 'package:inha_notice/widgets/notice_list_tile.dart';
import 'package:inha_notice/widgets/pagination/relative_style_pagination.dart';
import 'package:inha_notice/widgets/refresh_button.dart';
import 'package:inha_notice/widgets/rounded_toggle_button.dart';

class RelativeStyleNoticeBoard extends BaseNoticeBoard {
  final String noticeType;

  const RelativeStyleNoticeBoard({super.key, required this.noticeType});

  @override
  State<RelativeStyleNoticeBoard> createState() =>
      _RelativeStyleNoticeBoardState();
}

class _RelativeStyleNoticeBoardState
    extends BaseNoticeBoardState<RelativeStyleNoticeBoard> {
  late BaseRelativeStyleNoticeScraper libraryScraper;
  bool showHeadlines = false;
  bool showGeneral = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initializeScraper() async {
    if (widget.noticeType == 'LIBRARY') {
      libraryScraper = LibraryScraper();
    }
  }

  @override
  Future<void> initialize() async {
    try {
      await initializeScraper();
      await loadNotices(PageSettings.kInitialRelativePage); // 공지사항 로드
    } catch (e) {
      // 에러 처리
      debugPrint('Initialization error: $e');
    }
  }

  @override
  void toggleOption(String option) {
    setState(() {
      if (option == 'headline') {
        showHeadlines = true;
        showGeneral = false;
      } else if (option == 'general') {
        showHeadlines = false;
        showGeneral = true;
      }
    });
  }

  Future<void> loadNotices(int offset) async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedNotices = await libraryScraper.fetchNotices(offset);
      if (!mounted) return;
      setState(() {
        notices = fetchedNotices;
        if (offset == PageSettings.kInitialRelativePage &&
            initialPages.isEmpty) {
          initialPages = List<Map<String, dynamic>>.from(notices['pages']);
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
                isSelected: showHeadlines,
                onTap: toggleOption),
          const SizedBox(width: 10),
          // 일반공지 버튼
          RoundedToggleButton(
              text: '일반',
              option: 'general',
              isSelected: showGeneral,
              onTap: toggleOption),
          const Spacer(),
          // 공지사항 새로고침
          RefreshButton(onTap: () {
            loadNotices(PageSettings.kInitialRelativePage);
          }),
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
            : ListView.builder(
                // 중요 공지와 일반 공지 중 하나만 선택이 가능합니다.
                itemCount: showHeadlines
                    ? notices['headline'].length
                    : notices['general'].length,
                itemBuilder: (context, index) {
                  final notice = showHeadlines
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
    );
  }

  @override
  Widget buildFooter() {
    if (initialPages.isEmpty || showHeadlines) return const SizedBox();
    return RelativeStylePagination(
      pageType: 'LIBRARY',
      pages: initialPages,
      currentPage: currentPage,
      loadNotices: loadNotices,
    );
  }
}
