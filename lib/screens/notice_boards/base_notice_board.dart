import 'package:flutter/material.dart';
import 'package:inha_notice/utils/read_notice_manager.dart';
import 'package:inha_notice/utils/bookmark_manager.dart';
import 'package:inha_notice/constants/page_constants.dart';
import 'package:inha_notice/services/whole_notice_scraper.dart';

// 공지사항 페이지의 인터페이스를 제공합니다.
abstract class BaseNoticeBoard extends StatefulWidget {
  const BaseNoticeBoard({super.key});
}

abstract class BaseNoticeBoardState<T extends BaseNoticeBoard> extends State<T> {
  final WholeNoticeScraper wholeApi = WholeNoticeScraper();
  late Map<String, dynamic> notices = {'headline': [], 'general': [], 'pages': []};
  late List<Map<String, dynamic>> initialPages = [];
  late Set<String> readNotices = {};
  late Set<String> bookmarkedNotices = {};

  bool isLoading = true;
  bool showHeadlines = false;
  bool showGeneral = true;
  int currentPage = PageSettings.kInitialPage;

  @override
  void initState() {
    super.initState();
    initializeReadAndBookmark().then((_) {
      loadNotices(PageSettings.kInitialPage);
    });
  }

  // override 필요
  Future<void> loadNotices(int page);

  Future<void> initializeReadAndBookmark() async {
    final readIds = await ReadNoticeManager.loadReadNotices();
    final bookmarkedIds = await BookmarkManager.getAllBookmarks();
    readNotices = readIds.toSet();
    bookmarkedNotices = bookmarkedIds.toSet();
  }

  // 공지를 읽었는지 확인
  bool isNoticeRead(String noticeId) {
    return readNotices.contains(noticeId);
  }

  // 공지가 북마크되었는지 확인
  bool isNoticeBookmarked(String noticeId) {
    return bookmarkedNotices.contains(noticeId);
  }

  // 공지를 읽음으로 표시
  Future<void> markNoticeAsRead(String noticeId) async {
    readNotices.add(noticeId);
    await ReadNoticeManager.saveReadNotices(readNotices);
    setState(() {});
  }

  // 공지의 북마크 상태를 토글
  Future<void> toggleBookmark(String noticeId) async {
    if (bookmarkedNotices.contains(noticeId)) {
      bookmarkedNotices.remove(noticeId);
      await BookmarkManager.removeBookmark(noticeId);
    } else {
      bookmarkedNotices.add(noticeId);
      await BookmarkManager.addBookmark(noticeId);
    }
    setState(() {});
  }

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

  Widget buildHeader();

  Widget buildMain();

  Widget buildFooter();
}