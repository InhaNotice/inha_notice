import 'package:flutter/material.dart';
import 'package:inha_notice/constants/font_constants.dart';
import 'package:inha_notice/constants/page_constants.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/bottom_navigation/more/major_setting_page.dart';
import 'package:inha_notice/screens/notice_board/base_notice_board.dart';
import 'package:inha_notice/services/absolute_style_scraper/base_notice_scraper.dart';
import 'package:inha_notice/services/absolute_style_scraper/major_style_notice_scraper.dart';
import 'package:inha_notice/services/absolute_style_scraper/whole_notice_scraper.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/shared_prefs_manager.dart';
import 'package:inha_notice/widgets/notice_list_tile.dart';
import 'package:inha_notice/widgets/pagination/absolute_style_pagination.dart';

/// noticeType에 따른 공지사항 페이지 구현
/// 지원하는 공지: 학사, 학과, 국제처, SW중심대학
class NoticeBoard extends BaseNoticeBoard {
  final String noticeType;

  const NoticeBoard({super.key, required this.noticeType});

  @override
  State<NoticeBoard> createState() => NoticeBoardState();
}

class NoticeBoardState extends BaseNoticeBoardState<NoticeBoard> {
  late BaseNoticeScraper noticeScraper;
  late String? majorKey;
  bool showHeadlines = false;
  bool showGeneral = true;
  bool isMajorKey = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> loadMajorPreference() async {
    majorKey = SharedPrefsManager().getMajorKey();
    isMajorKey = (majorKey != null) ? true : false;
  }

  Future<void> initializeScraper() async {
    if (widget.noticeType == 'MAJOR') {
      await loadMajorPreference();
      if (!isMajorKey) return; // 학과가 없으면 초기화하지 않음
    }

    if (widget.noticeType == 'WHOLE') {
      noticeScraper = WholeNoticeScraper();
    } else if (widget.noticeType == 'MAJOR') {
      noticeScraper = MajorStyleNoticeScraper(majorKey!);
    } else {
      noticeScraper = MajorStyleNoticeScraper(widget.noticeType);
    }
  }

  // override 메서드
  @override
  Future<void> initialize() async {
    try {
      await initializeScraper(); // 스크레이퍼 초기화
      await initializeReadAndBookmark(); // 읽은 공지와 북마크 초기화
      await loadNotices(PageSettings.kInitialAbsolutePage); // 공지사항 로드
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
        if (page == PageSettings.kInitialAbsolutePage && initialPages.isEmpty) {
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
              loadNotices(PageSettings.kInitialAbsolutePage);
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
            : (widget.noticeType == 'MAJOR' && !isMajorKey)
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // 내용물이 중앙에 정렬되도록 설정
                      children: [
                        Text(
                          '학과를 설정해주세요!',
                          style: TextStyle(
                            fontFamily: Font.kDefaultFont,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                        const SizedBox(height: 12), // 텍스트와 버튼 사이 여백 추가
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).buttonBackgroundColor,
                            foregroundColor: Colors.white, // 텍스트 색상
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // 버튼 모서리 둥글게
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MajorSettingPage()),
                            );
                          },
                          icon: Icon(Icons.school_outlined,
                              size: 20,
                              color: Theme.of(context)
                                  .appBarTheme
                                  .iconTheme
                                  ?.color),
                          label: Text(
                            '학과 설정하기',
                            style: TextStyle(
                              fontFamily: Font.kDefaultFont,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color ??
                                  Theme.of(context).defaultColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
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
    return AbsoluteStylePagination(
      pages: initialPages,
      currentPage: currentPage,
      loadNotices: loadNotices,
    );
  }
}
