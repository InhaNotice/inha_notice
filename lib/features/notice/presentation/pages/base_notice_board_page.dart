/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-18
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/constants/page_constants.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/core/utils/read_notice_manager.dart';
import 'package:inha_notice/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:inha_notice/injection_container.dart' as di;

/// **BaseNoticeBoardPage**
///
/// 이 클래스는 공지사항을 표시하는 기본적인 인터페이스를 제공하는 추상 클래스입니다.
///
/// ### 주요 기능:
/// - 공지사항의 읽음 상태 관리
/// - 공지사항 북마크 기능 제공
/// - 공통적인 UI 구조 (`buildHeader()`, `buildMain()`, `buildFooter()`) 제공
abstract class BaseNoticeBoardPage extends StatefulWidget {
  const BaseNoticeBoardPage({super.key});
}

abstract class BaseNoticeBoardPageState<T extends BaseNoticeBoardPage>
    extends State<T> {
  Map<String, dynamic> notices = {
    'headline': [],
    'general': [],
    'pages': createPages(),
  };
  Pages pages = createPages();

  bool isLoading = true;
  int currentPage = PageConstants.kInitialAbsolutePage;

  /// **공지 읽음 여부 확인**
  bool isNoticeRead(String noticeId) {
    return ReadNoticeManager.isReadNotice(noticeId);
  }

  /// **공지 북마크 여부 확인 (캐싱 활용)**
  bool isNoticeBookmarked(String noticeId) {
    return di.sl<BookmarkLocalDataSource>().isBookmarked(noticeId);
  }

  /// **공지 읽음 처리 (캐싱 활용)**
  Future<void> markNoticeAsRead(String noticeId) async {
    await ReadNoticeManager.addReadNotice(noticeId);
    setState(() {});
  }

  /// **공지의 북마크 상태 토글 (캐싱 반영)**
  Future<void> toggleBookmark(NoticeTileModel notice) async {
    if (isNoticeBookmarked(notice.id)) {
      await di.sl<BookmarkLocalDataSource>().removeBookmark(notice.id);
      if (!mounted) return;
      AppSnackBar.success(context, '삭제되었습니다.');
    } else {
      await di.sl<BookmarkLocalDataSource>().addBookmark(notice);
      if (!mounted) return;
      AppSnackBar.success(context, '저장되었습니다.');
    }
    setState(() {});
  }

  Widget buildHeader();

  Widget buildMain();

  Widget buildFooter();
}
