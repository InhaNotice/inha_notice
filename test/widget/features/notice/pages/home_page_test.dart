/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-20
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:inha_notice/features/bookmark/data/models/bookmark_model.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_user_setting_value_by_notice_type_use_case.dart';
import 'package:inha_notice/features/notice/domain/entities/home_tab_entity.dart';
import 'package:inha_notice/features/notice/domain/entities/notice_board_entity.dart';
import 'package:inha_notice/features/notice/domain/failures/home_failure.dart';
import 'package:inha_notice/features/notice/domain/failures/notice_board_failure.dart';
import 'package:inha_notice/features/notice/domain/repositories/home_repository.dart';
import 'package:inha_notice/features/notice/domain/repositories/notice_board_repository.dart';
import 'package:inha_notice/features/notice/domain/usecases/get_home_tabs_use_case.dart';
import 'package:inha_notice/features/notice/domain/usecases/get_notices_use_case.dart';
import 'package:inha_notice/features/notice/presentation/bloc/home_bloc.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_bloc.dart';
import 'package:inha_notice/features/notice/presentation/pages/home_page.dart';
import 'package:inha_notice/features/notice/presentation/widgets/notice_board_tab_widget.dart';
import 'package:inha_notice/injection_container.dart' as di;

import '../../../support/widget_test_pump_app.dart';

class _FakeSharedPrefsManager extends SharedPrefsManager {
  _FakeSharedPrefsManager() : super(null);

  final Map<String, dynamic> values = {};

  @override
  T? getValue<T>(String key) {
    final value = values[key];
    if (value is T) return value;
    return null;
  }
}

class _FakeBookmarkLocalDataSource implements BookmarkLocalDataSource {
  final Set<String> ids = {};

  @override
  Future<void> addBookmark(NoticeTileModel notice) async {
    ids.add(notice.id);
  }

  @override
  Future<void> clearBookmarks() async {
    ids.clear();
  }

  @override
  Set<String> getBookmarkIds() => ids;

  @override
  Future<BookmarkModel> getBookmarks() async {
    return const BookmarkModel(bookmarks: []);
  }

  @override
  Future<void> initialize() async {}

  @override
  bool isBookmarked(String noticeId) => ids.contains(noticeId);

  @override
  Future<void> removeBookmark(String noticeId) async {
    ids.remove(noticeId);
  }
}

class _FakeHomeRepository implements HomeRepository {
  Either<HomeFailure, List<HomeTabEntity>> tabsResult = const Right([]);

  @override
  Future<Either<HomeFailure, List<HomeTabEntity>>> getHomeTabs() async {
    return tabsResult;
  }
}

class _FakeNoticeBoardRepository implements NoticeBoardRepository {
  Either<NoticeBoardFailure, NoticeBoardEntity> absoluteResult = Right(
    NoticeBoardEntity(
      headlineNotices: const [],
      generalNotices: const [
        NoticeTileModel(
          id: '1',
          title: '일반 공지 A',
          link: 'https://example.com/a',
          date: '2026-02-19',
        ),
      ],
      pages: createPages(),
    ),
  );

  @override
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchAbsoluteNotices({
    required String noticeType,
    required int page,
    String? searchColumn,
    String? searchWord,
  }) async {
    return absoluteResult;
  }

  @override
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchRelativeNotices({
    required String noticeType,
    required int offset,
  }) async {
    return absoluteResult;
  }
}

void main() {
  group('HomePage 위젯 테스트', () {
    late _FakeHomeRepository homeRepository;
    late _FakeNoticeBoardRepository noticeBoardRepository;

    setUp(() async {
      await di.sl.reset();

      homeRepository = _FakeHomeRepository();
      noticeBoardRepository = _FakeNoticeBoardRepository();

      final prefs = _FakeSharedPrefsManager();

      di.sl.registerLazySingleton<SharedPrefsManager>(() => prefs);
      di.sl.registerLazySingleton<BookmarkLocalDataSource>(
          () => _FakeBookmarkLocalDataSource());

      di.sl.registerFactory<HomeBloc>(
        () => HomeBloc(
          getHomeTabsUsecase: GetHomeTabsUseCase(homeRepository),
        ),
      );

      di.sl.registerFactory<NoticeBoardBloc>(
        () => NoticeBoardBloc(
          getAbsoluteNoticesUseCase:
              GetAbsoluteNoticesUseCase(repository: noticeBoardRepository),
          getRelativeNoticesUseCase:
              GetRelativeNoticesUseCase(repository: noticeBoardRepository),
          getUserSettingValueByNoticeTypeUseCase:
              GetUserSettingValueByNoticeTypeUseCase(sharedPrefsManager: prefs),
        ),
      );
    });

    tearDown(() async {
      await di.sl.reset();
    });

    testWidgets('홈 탭 로딩 성공 시 탭과 공지 목록을 렌더링한다', (tester) async {
      homeRepository.tabsResult = const Right([
        HomeTabEntity(noticeType: 'WHOLE', label: '홈탭1'),
        HomeTabEntity(noticeType: 'SCHOLARSHIP', label: '홈탭2'),
      ]);

      await pumpInhaApp(
        tester,
        child: const HomePage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('홈탭1'), findsOneWidget);
      expect(find.text('홈탭2'), findsOneWidget);
      expect(find.byType(NoticeBoardTabWidget), findsOneWidget);
      expect(find.text('일반 공지 A'), findsOneWidget);
    });

    testWidgets('홈 탭 로딩 실패 시 에러 텍스트를 표시한다', (tester) async {
      homeRepository.tabsResult = const Left(HomeFailure.tabs('홈 탭 로딩 실패'));

      await pumpInhaApp(
        tester,
        child: const HomePage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('홈 탭 로딩 실패'), findsOneWidget);
    });
  });
}
