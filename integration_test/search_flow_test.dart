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
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:inha_notice/features/bookmark/data/models/bookmark_model.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_user_setting_value_by_notice_type_use_case.dart';
import 'package:inha_notice/features/main/domain/usecases/get_initial_notification_message.dart';
import 'package:inha_notice/features/main/presentation/bloc/main_navigation_bloc.dart';
import 'package:inha_notice/features/main/presentation/pages/main_navigation_page.dart';
import 'package:inha_notice/features/notice/domain/entities/home_tab_entity.dart';
import 'package:inha_notice/features/notice/domain/entities/notice_board_entity.dart';
import 'package:inha_notice/features/notice/domain/failures/home_failure.dart';
import 'package:inha_notice/features/notice/domain/failures/notice_board_failure.dart';
import 'package:inha_notice/features/notice/domain/repositories/home_repository.dart';
import 'package:inha_notice/features/notice/domain/repositories/notice_board_repository.dart';
import 'package:inha_notice/features/notice/domain/usecases/get_home_tabs_use case.dart';
import 'package:inha_notice/features/notice/domain/usecases/get_notices_use_case.dart';
import 'package:inha_notice/features/notice/presentation/bloc/home_bloc.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_bloc.dart';
import 'package:inha_notice/features/notification/domain/entities/notification_message_entity.dart';
import 'package:inha_notice/features/notification/domain/repositories/notification_repository.dart';
import 'package:inha_notice/features/search/domain/entities/trending_topic_entity.dart';
import 'package:inha_notice/features/search/domain/failures/search_failure.dart';
import 'package:inha_notice/features/search/domain/repositories/search_repository.dart';
import 'package:inha_notice/features/search/domain/usecases/add_recent_search_word_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/clear_recent_search_words_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/get_recent_search_words_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/get_trending_topics_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/remove_recent_search_word_use_case.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_bloc.dart';
import 'package:inha_notice/injection_container.dart' as di;
import 'package:integration_test/integration_test.dart';

class _FakeSharedPrefsManager extends SharedPrefsManager {
  _FakeSharedPrefsManager() : super(null);
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
  @override
  Future<Either<HomeFailure, List<HomeTabEntity>>> getHomeTabs() async {
    return const Right([
      HomeTabEntity(noticeType: 'WHOLE', label: '학사'),
    ]);
  }
}

class _FakeNoticeBoardRepository implements NoticeBoardRepository {
  @override
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchAbsoluteNotices({
    required String noticeType,
    required int page,
    String? searchColumn,
    String? searchWord,
  }) async {
    return Right(
      NoticeBoardEntity(
        headlineNotices: const [],
        generalNotices: const [
          NoticeTileModel(
            id: 'n1',
            title: '통합 검색 테스트용 공지',
            link: 'https://example.com/notice',
            date: '2026-02-19',
          ),
        ],
        pages: createPages(),
      ),
    );
  }

  @override
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchRelativeNotices({
    required String noticeType,
    required int offset,
  }) async {
    return fetchAbsoluteNotices(noticeType: noticeType, page: 1);
  }
}

class _FakeSearchRepository implements SearchRepository {
  List<String> recentWords = ['학사', '장학'];

  @override
  Future<Either<SearchFailure, void>> addRecentSearchWord(String query) async {
    recentWords = [query, ...recentWords.where((e) => e != query)];
    return const Right(null);
  }

  @override
  Future<Either<SearchFailure, void>> clearRecentSearchWords() async {
    recentWords = [];
    return const Right(null);
  }

  @override
  List<String> getRecentSearchWords() => List<String>.from(recentWords);

  @override
  Future<Either<SearchFailure, List<TrendingTopicEntity>>>
      getTrendingTopics() async {
    return const Right([
      TrendingTopicEntity(
        id: '1',
        queryCount: '1',
        count: '10',
        updown: 'U',
        text: '컴퓨터공학과',
        makeTimes: '12:00',
      ),
    ]);
  }

  @override
  Future<Either<SearchFailure, void>> removeRecentSearchWord(
      String query) async {
    recentWords.remove(query);
    return const Right(null);
  }
}

class _FakeNotificationRepository implements NotificationRepository {
  @override
  Future<NotificationMessageEntity> getNotificationMessage() async {
    return const NotificationMessageEntity(id: null, link: null);
  }

  @override
  Future<void> requestPermission() async {}
}

Future<void> _registerDependencies() async {
  await di.sl.reset();

  final prefs = _FakeSharedPrefsManager();
  final homeRepository = _FakeHomeRepository();
  final noticeRepository = _FakeNoticeBoardRepository();
  final searchRepository = _FakeSearchRepository();
  final notificationRepository = _FakeNotificationRepository();

  di.sl.registerLazySingleton<SharedPrefsManager>(() => prefs);
  di.sl.registerLazySingleton<BookmarkLocalDataSource>(
      () => _FakeBookmarkLocalDataSource());

  di.sl.registerFactory<MainNavigationBloc>(
    () => MainNavigationBloc(
      getInitialNotificationMessage:
          GetInitialNotificationMessage(repository: notificationRepository),
    ),
  );
  di.sl.registerFactory<HomeBloc>(
    () => HomeBloc(
      getHomeTabsUsecase: GetHomeTabsUseCase(homeRepository),
    ),
  );
  di.sl.registerFactory<NoticeBoardBloc>(
    () => NoticeBoardBloc(
      getAbsoluteNoticesUseCase:
          GetAbsoluteNoticesUseCase(repository: noticeRepository),
      getRelativeNoticesUseCase:
          GetRelativeNoticesUseCase(repository: noticeRepository),
      getUserSettingValueByNoticeTypeUseCase:
          GetUserSettingValueByNoticeTypeUseCase(sharedPrefsManager: prefs),
    ),
  );
  di.sl.registerFactory<SearchBloc>(
    () => SearchBloc(
      getTrendingTopics: GetTrendingTopicsUseCase(searchRepository),
      getRecentSearchWords: GetRecentSearchWordsUseCase(searchRepository),
      addRecentSearchWord: AddRecentSearchWordUseCase(searchRepository),
      removeRecentSearchWord: RemoveRecentSearchWordUseCase(searchRepository),
      clearRecentSearchWords: ClearRecentSearchWordsUseCase(searchRepository),
    ),
  );
}

Future<void> _pumpMainNavigation(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: MainNavigationPage(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 600));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('검색 통합 시나리오', () {
    tearDown(() async {
      await di.sl.reset();
    });

    testWidgets('검색 탭 진입 후 최근 검색어 삭제와 짧은 검색어 방어를 검증한다', (tester) async {
      await _registerDependencies();
      await _pumpMainNavigation(tester);

      await tester.tap(find.text('검색'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('최근 검색어'), findsOneWidget);
      expect(find.text('학사'), findsOneWidget);
      expect(find.text('장학'), findsOneWidget);

      await tester.tap(find.text('전체삭제'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('최근 검색 기록이 없습니다.'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'a');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.textContaining('검색 결과:'), findsNothing);
      expect(find.text('최근 검색어'), findsOneWidget);
    });
  });
}
