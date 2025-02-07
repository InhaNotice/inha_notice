import 'package:flutter/material.dart';
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
import 'package:inha_notice/widgets/refresh_button.dart';
import 'package:inha_notice/widgets/rounded_toggle_button.dart';
import 'package:logger/logger.dart';

/// **NoticeBoard**
///
/// 이 클래스는 noticeType에 따른 공지사항을 제공하는 클래스입니다.
///
/// ### 주요 기능:
/// - noticeType에 따른 공지사항 제공
/// - 지원하는 noticeType: 학사공지, 학과공지, 국제처 공지, SW중심대학 공지
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
  final logger = Logger();

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
      // 저장된 나의 학과 불러오기
      await loadMajorPreference();
      // 저장된 나의 학과가 없다면 스크래퍼 초기화를 하지 않음
      if (!isMajorKey) return;
    }

    // 스크래퍼 초기화 진행
    if (widget.noticeType == 'WHOLE') {
      noticeScraper = WholeNoticeScraper();
    } else if (widget.noticeType == 'MAJOR') {
      noticeScraper = MajorStyleNoticeScraper(majorKey!);
    } else {
      noticeScraper = MajorStyleNoticeScraper(widget.noticeType);
    }
  }

  /// 초기화 순서(순서를 보장해야함): 스크래퍼 초기화 -> 공지사항 불러오기
  @override
  Future<void> initialize() async {
    try {
      await initializeScraper();
      await loadNotices(PageSettings.kInitialAbsolutePage);
    } catch (e) {
      logger.e('NoticeBoard 초기화 오류: $e');
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

  /// 공지사항 새로고침 진행하는 함수
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
        // 페이지 리스트는 최초 로딩시 할당됨
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

  /// NoticeBoard 구조: Header(토글 버튼), Main(공지사항 리스트), Footer(페이지 버튼)
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

  /// buildHeader: 토글 버튼 영역 정의
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
          // 공지사항 새로고침 버튼
          RefreshButton(onTap: () {
            loadNotices(PageSettings.kInitialAbsolutePage);
          }),
        ],
      ),
    );
  }

  /// buildMain: 공지사항 리스트 영역 정의
  @override
  Widget buildMain() {
    return Expanded(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : (widget.noticeType == 'MAJOR' && !isMajorKey)
                ? Center(
                    // noticeType이 'MAJOR'이고 저장된 나의 학과가 존재하지 않을 때
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // 중앙 정렬
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
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).buttonBackgroundColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
                // 모든 noticeType에 대응
                : ListView.builder(
                    // 중요 공지와 일반 공지 중 하나만 선택이 가능
                    itemCount: showHeadlines
                        ? notices['headline'].length
                        : notices['general'].length,
                    itemBuilder: (context, index) {
                      final notice = showHeadlines
                          ? notices['headline'][index]
                          : notices['general'][index];
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

  /// buildFooter: 페이지 버튼 정의
  @override
  Widget buildFooter() {
    // 페이지 리스트가 초기화 되지 않았을 때
    if (initialPages.isEmpty || showHeadlines) return const SizedBox();
    // 페이지 리스트가 초기화 되었을 때
    return AbsoluteStylePagination(
      pages: initialPages,
      currentPage: currentPage,
      loadNotices: loadNotices,
    );
  }
}
