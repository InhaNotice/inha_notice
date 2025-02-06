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

  bool isLoading = true;
  int currentPage = PageSettings.kInitialAbsolutePage;

  /// **공지 읽음 여부 확인**
  bool isNoticeRead(String noticeId) {
    return ReadNoticeManager.isReadNotice(noticeId);
  }

  /// **공지 북마크 여부 확인 (캐싱 활용)**
  bool isNoticeBookmarked(String noticeId) {
    return BookmarkManager.isBookmarked(noticeId);
  }

  /// **공지 읽음 처리 (캐싱 활용)**
  void markNoticeAsRead(String noticeId) {
    setState(() {
      ReadNoticeManager.addReadNotice(noticeId);
    });
  }

  /// **공지의 북마크 상태 토글 (캐싱 반영)**
  Future<void> toggleBookmark(Map<String, dynamic> notice) async {
    if (isNoticeBookmarked(notice['id'])) {
      await BookmarkManager.removeBookmark(notice['id']);
    } else {
      await BookmarkManager.addBookmark(notice);
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
