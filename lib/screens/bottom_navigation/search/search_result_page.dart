import 'package:flutter/material.dart';
import 'package:inha_notice/constants/font_constants.dart';
import 'package:inha_notice/constants/page_constants.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/notice_board/base_notice_board.dart';
import 'package:inha_notice/services/relative_style_scraper/search_scraper.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/widgets/notice_list_tile.dart';
import 'package:inha_notice/widgets/pagination/relative_style_pagination.dart';

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

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await initializeReadAndBookmark(); // 읽은 공지와 북마크 초기화
      await loadNotices(PageSettings.kInitialRelativePage); // 공지사항 로드
    } catch (e) {
      // 에러 처리
      debugPrint('Initialization error: $e');
    }
  }

  @override
  Future<void> loadNotices(int startCount) async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedNotices =
          await searchScraper.fetchNotices(widget.query, startCount);
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
      return super.build(context);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).appBarTheme.iconTheme?.color,
        ),
        title: Text(
          '검색 결과: ${widget.query}',
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultColor,
          ),
        ),
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
          // 중요공지가 있을때만 토글 버튼이 생성됩니다.
          if (notices['headline'].isNotEmpty)
            GestureDetector(
              onTap: () => toggleOption('headline'),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  // 옵션 버튼의 경계 색상 지정
                  border: showHeadlines
                      ? Border.all(color: Colors.blue, width: 2.0)
                      : Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  '중요',
                  style: TextStyle(
                    fontFamily: FontSettings.kDefaultFont,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: showHeadlines ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => toggleOption('general'),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                // 옵션 버튼의 경계 색상 지정
                border: showGeneral
                    ? Border.all(color: Colors.blue, width: 2.0)
                    : Border.all(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                '정확도순',
                style: TextStyle(
                    fontFamily: FontSettings.kDefaultFont,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: showGeneral ? Colors.blue : Colors.grey),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              loadNotices(PageSettings.kInitialRelativePage);
            },
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                    color: Theme.of(context).iconTheme.color!, width: 2.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Icon(
                Icons.refresh,
                color: Theme.of(context).iconTheme.color,
                size: 16.0,
              ),
            ),
          ),
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
                    noticeType: showHeadlines ? 'headline' : 'general',
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
    if (!widget.isSearchResultPage) {
      return RelativeStylePagination(
        pageType: 'SEARCH',
        pages: initialPages,
        currentPage: currentPage,
        loadNotices: loadNotices,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0), // ✅ 위아래 여백 추가
      child: RelativeStylePagination(
        pageType: 'SEARCH',
        pages: initialPages,
        currentPage: currentPage,
        loadNotices: loadNotices,
      ),
    );
  }
}
