import 'package:flutter/material.dart';
import 'package:inha_notice/constants/font_constants.dart';
import 'package:inha_notice/constants/page_constants.dart';
import 'package:inha_notice/screens/notice_board/base_notice_board.dart';
import 'package:inha_notice/services/scraper/major_style_notice_scraper.dart';
import 'package:inha_notice/services/scraper/whole_notice_scraper.dart';
import 'package:inha_notice/widgets/notice_list_tile.dart';
import 'package:inha_notice/widgets/page_selector.dart';

// noticeType에 따라 공지사항 페이지를 구현합니다.
class NoticeBoard extends BaseNoticeBoard {
  final String noticeType;

  const NoticeBoard({super.key, required this.noticeType});

  @override
  State<NoticeBoard> createState() => NoticeBoardState();
}

class NoticeBoardState extends BaseNoticeBoardState<NoticeBoard> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await initializeScraper(); // 스크레이퍼 초기화
      await initializeReadAndBookmark(); // 읽은 공지와 북마크 초기화
      await loadNotices(PageSettings.kInitialPage); // 공지사항 로드
    } catch (e) {
      // 에러 처리
      debugPrint('Initialization error: $e');
    }
  }

  Future<void> initializeScraper() async {
    if (widget.noticeType == 'WHOLE') {
      noticeScraper = WholeNoticeScraper();
    } else if (widget.noticeType == 'MAJOR') {
      final majorScraper = MajorStyleNoticeScraper(widget.noticeType);
      await majorScraper.initialize();
      noticeScraper = majorScraper;
    } else if (widget.noticeType == 'INTERNATIONAL') {
      noticeScraper = MajorStyleNoticeScraper(widget.noticeType);
    } else if (widget.noticeType == 'SWUNIV') {
      noticeScraper = MajorStyleNoticeScraper(widget.noticeType);
    }
  }

  @override
  Future<void> loadNotices(int page) async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedNotices =
          await noticeScraper.fetchNotices(page, widget.noticeType);
      if (!mounted) return;
      setState(() {
        notices = fetchedNotices;
        if (page == PageSettings.kInitialPage && initialPages.isEmpty) {
          initialPages = List<Map<String, dynamic>>.from(notices['pages']);
        }
        currentPage = page;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
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
                '일반',
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
              loadNotices(PageSettings.kInitialPage);
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
                    markAsRead: markNoticeAsRead,
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
    return PageSelector(
      pages: initialPages,
      currentPage: currentPage,
      onPageSelected: (page) {
        loadNotices(page);
      },
    );
  }
}
