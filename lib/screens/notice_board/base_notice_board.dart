import 'package:flutter/material.dart';
import 'package:inha_notice/constants/page_constants.dart';
import 'package:inha_notice/utils/bookmark_manager.dart';
import 'package:inha_notice/utils/read_notice_manager.dart';

/// **BaseNoticeBoard**
///
/// 이 클래스는 공지사항을 표시하는 기본적인 인터페이스를 제공하는 추상 클래스입니다.
///
/// ### 주요 기능:
/// - 공지사항의 읽음 상태 관리
/// - 공지사항 북마크 기능 제공
/// - 공통적인 UI 구조 (`buildHeader()`, `buildMain()`, `buildFooter()`) 제공
abstract class BaseNoticeBoard extends StatefulWidget {
  const BaseNoticeBoard({super.key});
}

abstract class BaseNoticeBoardState<T extends BaseNoticeBoard>
    extends State<T> {
  // 추상 메서드
  Future<void> initialize();

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
  Future<void> markNoticeAsRead(String noticeId) async {
    await ReadNoticeManager.addReadNotice(noticeId);
    setState(() {});
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

  Widget buildHeader();

  Widget buildMain();

  Widget buildFooter();
}
