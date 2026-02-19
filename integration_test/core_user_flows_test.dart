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
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:inha_notice/features/bookmark/data/models/bookmark_model.dart';
import 'package:inha_notice/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:inha_notice/features/bookmark/domain/failures/bookmark_failure.dart';
import 'package:inha_notice/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/clear_bookmarks_use_case.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/get_bookmarks_use_case.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/remove_bookmark_use_case.dart';
import 'package:inha_notice/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_major_display_name_use_case.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_user_setting_value_by_notice_type_use_case.dart';
import 'package:inha_notice/features/main/domain/usecases/get_initial_notification_message.dart';
import 'package:inha_notice/features/main/presentation/bloc/main_navigation_bloc.dart';
import 'package:inha_notice/features/main/presentation/pages/main_navigation_page.dart';
import 'package:inha_notice/features/more/domain/entities/more_configuration_entity.dart';
import 'package:inha_notice/features/more/domain/failures/cache_failure.dart';
import 'package:inha_notice/features/more/domain/failures/more_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/cache_repository.dart';
import 'package:inha_notice/features/more/domain/repositories/more_repository.dart';
import 'package:inha_notice/features/more/domain/usecases/get_cache_size_use_case.dart';
import 'package:inha_notice/features/more/domain/usecases/get_web_urls_use_case.dart';
import 'package:inha_notice/features/more/presentation/bloc/cache_bloc.dart';
import 'package:inha_notice/features/more/presentation/bloc/more_bloc.dart';
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
import 'package:inha_notice/features/notification/domain/entities/notification_message_entity.dart';
import 'package:inha_notice/features/notification/domain/repositories/notification_repository.dart';
import 'package:inha_notice/features/notification_setting/domain/failures/notification_setting_failure.dart';
import 'package:inha_notice/features/notification_setting/domain/repositories/notification_setting_repository.dart';
import 'package:inha_notice/features/notification_setting/domain/usecases/get_subscription_status_use_case.dart';
import 'package:inha_notice/features/notification_setting/domain/usecases/toggle_subscription_use_case.dart';
import 'package:inha_notice/features/notification_setting/presentation/bloc/notification_setting_bloc.dart';
import 'package:inha_notice/features/search/domain/entities/trending_topic_entity.dart';
import 'package:inha_notice/features/search/domain/failures/search_failure.dart';
import 'package:inha_notice/features/search/domain/repositories/search_repository.dart';
import 'package:inha_notice/features/search/domain/usecases/add_recent_search_word_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/clear_recent_search_words_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/get_recent_search_words_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/get_trending_topics_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/remove_recent_search_word_use_case.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_bloc.dart';
import 'package:inha_notice/features/university_setting/domain/failures/university_setting_failure.dart';
import 'package:inha_notice/features/university_setting/domain/repositories/university_setting_repository.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/get_current_setting_use_case.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/save_major_setting_use_case.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/save_setting_use_case.dart';
import 'package:inha_notice/features/university_setting/presentation/bloc/university_setting_bloc.dart';
import 'package:inha_notice/injection_container.dart' as di;
import 'package:integration_test/integration_test.dart';

class _FakeSharedPrefsManager extends SharedPrefsManager {
  _FakeSharedPrefsManager() : super(null);

  final Map<String, dynamic> values = {
    SharedPrefKeys.kUserThemeSetting: '시스템 설정',
  };

  @override
  T? getValue<T>(String key) {
    final value = values[key];
    if (value is T) return value;
    return null;
  }

  @override
  Future<void> setValue<T>(String key, T value) async {
    values[key] = value;
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
          id: 'n1',
          title: '통합 테스트 공지',
          link: 'https://example.com/notice',
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

class _FakeSearchRepository implements SearchRepository {
  List<String> recentWords = ['학사'];

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
  List<String> getRecentSearchWords() {
    return List<String>.from(recentWords);
  }

  @override
  Future<Either<SearchFailure, List<TrendingTopicEntity>>>
      getTrendingTopics() async {
    return const Right([
      TrendingTopicEntity(
        id: '1',
        queryCount: '1',
        count: '10',
        updown: 'U',
        text: '인하',
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

class _FakeBookmarkRepository implements BookmarkRepository {
  @override
  Future<Either<BookmarkFailure, void>> clearBookmarks() async {
    return const Right(null);
  }

  @override
  Future<Either<BookmarkFailure, BookmarkEntity>> getBookmarks() async {
    return Right(const BookmarkEntity(bookmarks: []));
  }

  @override
  Future<Either<BookmarkFailure, void>> removeBookmark(int id) async {
    return const Right(null);
  }
}

class _FakeMoreRepository implements MoreRepository {
  @override
  Future<Either<MoreFailure, MoreConfigurationEntity>> getWebUrls() async {
    return const Right(
      MoreConfigurationEntity(
        appVersion: '1.0.0',
        featuresUrl: 'https://example.com/features',
        personalInformationUrl: 'https://example.com/privacy',
        termsAndConditionsOfServiceUrl: 'https://example.com/terms',
        introduceAppUrl: 'https://example.com/intro',
        questionsAndAnswersUrl: 'https://example.com/faq',
      ),
    );
  }
}

class _FakeCacheRepository implements CacheRepository {
  @override
  Future<Either<CacheFailure, String>> getCacheSize() async {
    return const Right('0.01 MB');
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

class _FakeNotificationSettingRepository
    implements NotificationSettingRepository {
  final Map<String, bool> subscriptions = {};

  @override
  Future<Either<NotificationSettingFailure, bool>> getSubscriptionStatus(
      String prefKey) async {
    return Right(subscriptions[prefKey] ?? false);
  }

  @override
  Future<Either<NotificationSettingFailure, Unit>> toggleSubscription({
    required String prefKey,
    required String fcmTopic,
    required bool value,
    bool isSynchronizedWithMajor = false,
  }) async {
    subscriptions[prefKey] = value;
    return const Right(unit);
  }
}

class _FakeUniversitySettingRepository implements UniversitySettingRepository {
  final Map<String, String?> currentValues = {};

  @override
  Future<Either<UniversitySettingFailure, String?>> getCurrentSetting(
      String prefKey) async {
    return Right(currentValues[prefKey]);
  }

  @override
  Future<Either<UniversitySettingFailure, Unit>> saveMajorSetting(
      String? oldKey, String newKey, String majorKeyType) async {
    currentValues[majorKeyType] = newKey;
    return const Right(unit);
  }

  @override
  Future<Either<UniversitySettingFailure, Unit>> saveSetting(
      String prefKey, String value) async {
    currentValues[prefKey] = value;
    return const Right(unit);
  }
}

Future<void> _registerTestDependencies({
  required List<HomeTabEntity> homeTabs,
  required _FakeSharedPrefsManager prefs,
  required _FakeUniversitySettingRepository universityRepository,
}) async {
  await di.sl.reset();

  final homeRepository = _FakeHomeRepository()..tabsResult = Right(homeTabs);
  final noticeRepository = _FakeNoticeBoardRepository();
  final searchRepository = _FakeSearchRepository();
  final bookmarkRepository = _FakeBookmarkRepository();
  final moreRepository = _FakeMoreRepository();
  final cacheRepository = _FakeCacheRepository();
  final notificationRepository = _FakeNotificationRepository();
  final notificationSettingRepository = _FakeNotificationSettingRepository();

  di.sl.registerLazySingleton<SharedPrefsManager>(() => prefs);
  di.sl.registerLazySingleton<BookmarkLocalDataSource>(
      () => _FakeBookmarkLocalDataSource());

  di.sl.registerFactory<MainNavigationBloc>(
    () => MainNavigationBloc(
      getInitialNotificationMessage: GetInitialNotificationMessage(
        repository: notificationRepository,
      ),
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

  di.sl.registerFactory<BookmarkBloc>(
    () => BookmarkBloc(
      getBookmarksUseCase: GetBookmarksUseCase(repository: bookmarkRepository),
      clearBookmarksUseCase:
          ClearBookmarksUseCase(repository: bookmarkRepository),
      removeBookmarkUseCase:
          RemoveBookmarkUseCase(repository: bookmarkRepository),
    ),
  );

  di.sl.registerFactory<MoreBloc>(
    () => MoreBloc(
      getWebUrlsUseCase: GetWebUrlsUseCase(repository: moreRepository),
    ),
  );

  di.sl.registerFactory<CacheBloc>(
    () => CacheBloc(
      getCacheSizeUseCase: GetCacheSizeUseCase(repository: cacheRepository),
    ),
  );

  di.sl.registerFactory<NotificationSettingBloc>(
    () => NotificationSettingBloc(
      getSubscriptionStatusUseCase: GetSubscriptionStatusUseCase(
          repository: notificationSettingRepository),
      toggleSubscriptionUseCase:
          ToggleSubscriptionUseCase(repository: notificationSettingRepository),
    ),
  );

  di.sl.registerFactory<UniversitySettingBloc>(
    () => UniversitySettingBloc(
      getCurrentSettingUseCase:
          GetCurrentSettingUseCase(repository: universityRepository),
      saveSettingUseCase: SaveSettingUseCase(repository: universityRepository),
      saveMajorSettingUseCase:
          SaveMajorSettingUseCase(repository: universityRepository),
      getMajorDisplayNameUseCase: GetMajorDisplayNameUseCase(),
    ),
  );
}

Future<void> _pumpMainApp(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const MainNavigationPage(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('핵심 통합 시나리오', () {
    tearDown(() async {
      await di.sl.reset();
    });

    testWidgets('앱 진입 후 홈 탭과 공지 목록을 표시한다', (tester) async {
      final prefs = _FakeSharedPrefsManager();
      final universityRepository = _FakeUniversitySettingRepository();
      await _registerTestDependencies(
        homeTabs: const [HomeTabEntity(noticeType: 'WHOLE', label: '학사')],
        prefs: prefs,
        universityRepository: universityRepository,
      );

      await _pumpMainApp(tester);

      expect(find.text('홈'), findsOneWidget);
      expect(find.text('학사'), findsOneWidget);
      expect(find.text('통합 테스트 공지'), findsOneWidget);
    });

    testWidgets('홈에서 알림 설정으로 이동해 토글을 변경한다', (tester) async {
      final prefs = _FakeSharedPrefsManager();
      final universityRepository = _FakeUniversitySettingRepository();
      await _registerTestDependencies(
        homeTabs: const [HomeTabEntity(noticeType: 'WHOLE', label: '학사')],
        prefs: prefs,
        universityRepository: universityRepository,
      );

      await _pumpMainApp(tester);

      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('알림 설정'), findsOneWidget);

      await tester.tap(find.byType(Switch).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.textContaining('활성화되었습니다.'), findsOneWidget);
    });

    testWidgets('더보기에서 테마를 변경하면 설정이 반영된다', (tester) async {
      final prefs = _FakeSharedPrefsManager();
      final universityRepository = _FakeUniversitySettingRepository();
      await _registerTestDependencies(
        homeTabs: const [HomeTabEntity(noticeType: 'WHOLE', label: '학사')],
        prefs: prefs,
        universityRepository: universityRepository,
      );

      await _pumpMainApp(tester);

      await tester.tap(find.text('더보기'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('테마'), findsOneWidget);

      await tester.tap(find.text('테마'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('화이트'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(prefs.getValue<String>(SharedPrefKeys.kUserThemeSetting), '화이트');
      expect(find.text('화이트'), findsOneWidget);
    });

    testWidgets('학과 탭에서 학과 설정 화면으로 이동 후 저장한다', (tester) async {
      final prefs = _FakeSharedPrefsManager();
      final universityRepository = _FakeUniversitySettingRepository();
      await _registerTestDependencies(
        homeTabs: const [HomeTabEntity(noticeType: 'MAJOR', label: '학과')],
        prefs: prefs,
        universityRepository: universityRepository,
      );

      await _pumpMainApp(tester);

      expect(find.text('학과 설정하기'), findsOneWidget);

      await tester.tap(find.text('학과 설정하기'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('학과 설정'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '컴퓨터공학과');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('컴퓨터공학과').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(
          universityRepository.currentValues[SharedPrefKeys.kMajorKey], 'CSE');
    });
  });
}
