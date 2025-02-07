import 'package:flutter/material.dart';
import 'package:inha_notice/constants/page_constants.dart';
import 'package:inha_notice/screens/notice_board/base_notice_board.dart';
import 'package:inha_notice/services/relative_style_scraper/search_scraper.dart';
import 'package:inha_notice/widgets/notice_list_tile.dart';
import 'package:inha_notice/widgets/pagination/relative_style_pagination.dart';
import 'package:inha_notice/widgets/refresh_button.dart';
import 'package:inha_notice/widgets/rounded_toggle_button.dart';
import 'package:inha_notice/widgets/themed_app_bar.dart';

class SearchResultPage extends BaseNoticeBoard {
  final String query;
  final bool isSearchResultPage;

  const SearchResultPage(
      {super.key, required this.query, required this.isSearchResultPage});

  @override
  State<SearchResultPage> createState() => _LibraryNoticeBoardState();
}

class _LibraryNoticeBoardState extends BaseNoticeBoardState<SearchResultPage> {
  SearchScraper searchScraper = SearchScraper();
  bool showRank = false;
  bool showDate = true;

  String sortedType = '';

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Future<void> initialize() async {
    try {
      await loadNotices(PageSettings.kInitialRelativePage); // 공지사항 로드
    } catch (e) {
      // 에러 처리
      debugPrint('Initialization error: $e');
    }
  }

  @override
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
      loadNotices(PageSettings.kInitialRelativePage);
    });
  }

  Future<void> loadNotices(int startCount) async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedNotices = await searchScraper.fetchNotices(
          widget.query, startCount, sortedType);
      if (!mounted) return;
      setState(() {
        notices = fetchedNotices;
        if (startCount == PageSettings.kInitialRelativePage &&
            initialPages.isEmpty) {
          initialPages = List<Map<String, dynamic>>.from(notices['pages']);
        }
        // offset을 통한 현재 페이지로 변환
        currentPage = (startCount ~/ 10) + 1;
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
      appBar: ThemedAppBar(
          title: '검색 결과: ${widget.query}', titleSize: 17, isCenter: true),
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
          RoundedToggleButton(
              text: '정확도순',
              option: 'RANK',
              isSelected: showRank,
              onTap: toggleOption),
          const SizedBox(width: 10),
          RoundedToggleButton(
              text: '최신순',
              option: 'DATE',
              isSelected: showDate,
              onTap: toggleOption),
          const Spacer(),
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
                itemCount: notices['general'].length,
                itemBuilder: (context, index) {
                  final notice = notices['general'][index];
                  // 공지 리스트에서 공지가 읽음 상태인지 확인하고, NoticeListTile에 그 상태를 전달합니다.
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

  @override
  Widget buildFooter() {
    // 중요공지 옵션일 경우 페이지 버튼을 숨기기
    if (initialPages.isEmpty) return const SizedBox();

    // SearchResultPage가 아닌 경우 padding을 추가하지 않음
    if (!widget.isSearchResultPage) {
      return RelativeStylePagination(
        pageType: 'SEARCH',
        pages: initialPages,
        currentPage: currentPage,
        loadNotices: loadNotices,
      );
    }

    // SearchResultPage인 경우 padding을 추가함
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: RelativeStylePagination(
        pageType: 'SEARCH',
        pages: initialPages,
        currentPage: currentPage,
        loadNotices: loadNotices,
      ),
    );
  }
}
