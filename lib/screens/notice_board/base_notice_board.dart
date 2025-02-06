import 'package:flutter/material.dart';
import 'package:inha_notice/constants/page_constants.dart';
import 'package:inha_notice/utils/bookmark_manager.dart';
import 'package:inha_notice/utils/read_notice_manager.dart';

// BaseNoticeBoard는 읽은/읽지 않은 공지와 북마크 기능을 제공하는 공지사항 인터페이스를 제공하는 클래스입니다.
abstract class BaseNoticeBoard extends StatefulWidget {
  const BaseNoticeBoard({super.key});
}

abstract class BaseNoticeBoardState<T extends BaseNoticeBoard>
    extends State<T> {
  // 추상 메서드
  Future<void> initialize();

  Future<void> loadNotices(int page);

  void toggleOption(String option);

  Map<String, dynamic> notices = {'headline': [], 'general': [], 'pages': []};
  List<Map<String, dynamic>> initialPages = [];

  // 읽은 공지사항과 북마크된 공지사항을 캐싱하여 메모리에서 관리.
  Set<String> readNotices = {};
  Set<String> bookmarkedNotices = {};

  bool isLoading = true;
  int currentPage = PageSettings.kInitialAbsolutePage;

  Future<void> initializeReadAndBookmark() async {
    final Set<String> readIds = await ReadNoticeManager.loadReadNotices();
    final Set<String> bookmarkedIds = await BookmarkManager.getAllBookmarks();
    readNotices = readIds;
    bookmarkedNotices = bookmarkedIds;
  }

  // 공지를 읽었는지 확인
  bool isNoticeRead(String noticeId) {
    return readNotices.contains(noticeId);
  }

  // 공지를 읽음으로 표시
  Future<void> markNoticeAsRead(String noticeId) async {
    readNotices.add(noticeId);
    await ReadNoticeManager.saveReadNotices(readNotices);
    setState(() {});
  }

  // 공지가 북마크되었는지 확인
  bool isNoticeBookmarked(String noticeId) {
    return bookmarkedNotices.contains(noticeId);
  }

  // 북마크 추가
  Future<void> addNoticeBookmarked(String noticeId) async {
    bookmarkedNotices.add(noticeId);
    await BookmarkManager.addBookmark(noticeId);
  }

  // 북마크 삭제
  Future<void> removeNoticeBookmarked(String noticeId) async {
    bookmarkedNotices.remove(noticeId);
    await BookmarkManager.removeBookmark(noticeId);
  }

  // 공지의 북마크 상태를 토글
  Future<void> toggleBookmark(String noticeId) async {
    if (isNoticeBookmarked(noticeId)) {
      removeNoticeBookmarked(noticeId);
    } else {
      addNoticeBookmarked(noticeId);
    }
    setState(() {});
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
