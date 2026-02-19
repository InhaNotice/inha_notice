/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/more/data/datasources/more_local_data_source.dart';
import 'package:inha_notice/features/more/data/datasources/oss_license_local_data_source.dart';
import 'package:inha_notice/features/more/data/datasources/theme_preference_local_data_source.dart';
import 'package:inha_notice/features/more/data/repositories/more_repository_impl.dart';
import 'package:inha_notice/features/more/data/repositories/oss_license_repository_impl.dart';
import 'package:inha_notice/features/more/domain/repositories/more_repository.dart';
import 'package:inha_notice/features/more/domain/usecases/get_oss_licenses_use_case.dart';
import 'package:inha_notice/features/more/domain/usecases/get_theme_preference_use_case.dart';
import 'package:inha_notice/features/more/domain/usecases/get_web_urls_use_case.dart';
import 'package:inha_notice/features/more/domain/usecases/set_theme_preference_use_case.dart';
import 'package:inha_notice/features/more/presentation/bloc/oss_license_bloc.dart';
import 'package:inha_notice/features/more/presentation/bloc/theme_preference_bloc.dart';
import 'package:inha_notice/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:inha_notice/features/notification/domain/repositories/notification_repository.dart';
import 'package:inha_notice/features/notification/domain/usecases/request_initial_permission_use_case.dart';
import 'package:inha_notice/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'features/bookmark/domain/repositories/bookmark_repository.dart';
import 'features/bookmark/domain/usecases/clear_bookmarks_use_case.dart';
import 'features/bookmark/domain/usecases/get_bookmarks_use_case.dart';
import 'features/bookmark/domain/usecases/remove_bookmark_use_case.dart';
import 'features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'features/custom_tab/data/datasources/custom_tab_local_data_source.dart';
import 'features/custom_tab/data/repositories/custom_tab_repository_impl.dart';
import 'features/custom_tab/domain/repositories/custom_tab_repository.dart';
import 'features/custom_tab/domain/usecases/get_major_display_name_use_case.dart';
import 'features/custom_tab/domain/usecases/get_selected_tabs_use_case.dart';
import 'features/custom_tab/domain/usecases/get_user_setting_value_by_notice_type_use_case.dart';
import 'features/custom_tab/domain/usecases/save_tabs_use_case.dart';
import 'features/custom_tab/presentation/bloc/custom_tab_bloc.dart';
import 'features/main/domain/usecases/get_initial_notification_message.dart';
import 'features/main/presentation/bloc/main_navigation_bloc.dart';
import 'features/more/data/datasources/cache_local_data_source.dart';
import 'features/more/data/repositories/cache_repository_impl.dart';
import 'features/more/data/repositories/theme_preference_repository_impl.dart';
import 'features/more/domain/repositories/cache_repository.dart';
import 'features/more/domain/repositories/oss_license_repository.dart';
import 'features/more/domain/repositories/theme_preference_repository.dart';
import 'features/more/domain/usecases/get_cache_size_use_case.dart';
import 'features/more/presentation/bloc/cache_bloc.dart';
import 'features/more/presentation/bloc/more_bloc.dart';
import 'features/notice/data/datasources/home_local_data_source.dart';
import 'features/notice/data/datasources/notice_board_remote_data_source.dart';
import 'features/notice/data/repositories/home_repository_impl.dart';
import 'features/notice/data/repositories/notice_board_repository_impl.dart';
import 'features/notice/domain/repositories/home_repository.dart';
import 'features/notice/domain/repositories/notice_board_repository.dart';
import 'features/notice/domain/usecases/get_home_tabs_use case.dart';
import 'features/notice/domain/usecases/get_notices_use_case.dart';
import 'features/notice/presentation/bloc/home_bloc.dart';
import 'features/notice/presentation/bloc/notice_board_bloc.dart';
import 'features/notification/data/datasources/firebase_remote_data_source.dart';
import 'features/notification_setting/data/datasources/notification_setting_local_data_source.dart';
import 'features/notification_setting/data/datasources/notification_setting_remote_data_source.dart';
import 'features/notification_setting/data/repositories/notification_setting_repository_impl.dart';
import 'features/notification_setting/domain/repositories/notification_setting_repository.dart';
import 'features/notification_setting/domain/usecases/get_subscription_status_use_case.dart';
import 'features/notification_setting/domain/usecases/toggle_subscription_use_case.dart';
import 'features/notification_setting/presentation/bloc/notification_setting_bloc.dart';
import 'features/search/data/datasources/recent_search_local_data_source.dart';
import 'features/search/data/datasources/search_local_data_source.dart';
import 'features/search/data/datasources/search_remote_data_source.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/domain/repositories/search_repository.dart';
import 'features/search/domain/usecases/add_recent_search_word_use_case.dart';
import 'features/search/domain/usecases/clear_recent_search_words_use_case.dart';
import 'features/search/domain/usecases/get_recent_search_words_use_case.dart';
import 'features/search/domain/usecases/get_trending_topics_use_case.dart';
import 'features/search/domain/usecases/remove_recent_search_word_use_case.dart';
import 'features/search/presentation/bloc/search_bloc.dart';
import 'features/university_setting/data/datasources/university_setting_local_data_source.dart';
import 'features/university_setting/data/repositories/university_setting_repository_impl.dart';
import 'features/university_setting/domain/repositories/university_setting_repository.dart';
import 'features/university_setting/domain/usecases/get_current_setting_use_case.dart';
import 'features/university_setting/domain/usecases/save_major_setting_use_case.dart';
import 'features/university_setting/domain/usecases/save_setting_use_case.dart';
import 'features/university_setting/presentation/bloc/university_setting_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => HomeBloc(getHomeTabsUsecase: sl()),
  );
  sl.registerFactory(
    () => BookmarkBloc(
        getBookmarksUseCase: sl(),
        clearBookmarksUseCase: sl(),
        removeBookmarkUseCase: sl()),
  );
  sl.registerFactory(() => SearchBloc(
        // 인기 검색어
        getTrendingTopics: sl(),
        // 최근 검색어
        getRecentSearchWords: sl(),
        addRecentSearchWord: sl(),
        removeRecentSearchWord: sl(),
        clearRecentSearchWords: sl(),
      ));
  sl.registerFactory(() => OnboardingBloc(requestPermissionUseCase: sl()));
  sl.registerFactory(() => MoreBloc(getWebUrlsUseCase: sl()));
  sl.registerFactory(() => CacheBloc(getCacheSizeUseCase: sl()));
  sl.registerFactory(() => OssLicenseBloc(getOssLicensesUseCase: sl()));
  sl.registerFactory(() => NoticeBoardBloc(
        getAbsoluteNoticesUseCase: sl(),
        getRelativeNoticesUseCase: sl(),
        getUserSettingValueByNoticeTypeUseCase: sl(),
      ));
  sl.registerFactory(
      () => MainNavigationBloc(getInitialNotificationMessage: sl()));
  sl.registerFactory(() => ThemePreferenceBloc(
      getThemePreferenceUseCase: sl(), setThemePreferenceUseCase: sl()));
  sl.registerFactory(() => CustomTabBloc(
        getSelectedTabsUseCase: sl(),
        saveTabsUseCase: sl(),
      ));
  sl.registerFactory(() => UniversitySettingBloc(
        getCurrentSettingUseCase: sl(),
        saveSettingUseCase: sl(),
        saveMajorSettingUseCase: sl(),
        getMajorDisplayNameUseCase: sl(),
      ));
  sl.registerFactory(() => NotificationSettingBloc(
        getSubscriptionStatusUseCase: sl(),
        toggleSubscriptionUseCase: sl(),
      ));

  // UseCase
  sl.registerLazySingleton(() => GetHomeTabsUseCase(sl()));
  sl.registerLazySingleton(() => GetAbsoluteNoticesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetRelativeNoticesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetBookmarksUseCase(repository: sl()));
  sl.registerLazySingleton(() => ClearBookmarksUseCase(repository: sl()));
  sl.registerLazySingleton(() => RemoveBookmarkUseCase(repository: sl()));
  sl.registerLazySingleton(
      () => RequestInitialPermissionUseCase(repository: sl()));
  // 인기 검색어
  sl.registerLazySingleton(() => GetTrendingTopicsUseCase(sl()));
  // 최근 검색어
  sl.registerLazySingleton(() => GetRecentSearchWordsUseCase(sl()));
  sl.registerLazySingleton(() => AddRecentSearchWordUseCase(sl()));
  sl.registerLazySingleton(() => RemoveRecentSearchWordUseCase(sl()));
  sl.registerLazySingleton(() => ClearRecentSearchWordsUseCase(sl()));
  sl.registerLazySingleton(
      () => GetInitialNotificationMessage(repository: sl()));
  sl.registerLazySingleton(() => GetWebUrlsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCacheSizeUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetOssLicensesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetThemePreferenceUseCase(repository: sl()));
  sl.registerLazySingleton(() => SetThemePreferenceUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetSelectedTabsUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveTabsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentSettingUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveSettingUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveMajorSettingUseCase(repository: sl()));
  sl.registerLazySingleton(
      () => GetSubscriptionStatusUseCase(repository: sl()));
  sl.registerLazySingleton(() => ToggleSubscriptionUseCase(repository: sl()));
  sl.registerLazySingleton(
      () => GetUserSettingValueByNoticeTypeUseCase(sharedPrefsManager: sl()));
  sl.registerLazySingleton(() => GetMajorDisplayNameUseCase());

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<NoticeBoardRepository>(
    () => NoticeBoardRepositoryImpl(
      remoteDataSource: sl(),
      sharedPrefsManager: sl(),
    ),
  );
  sl.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<MoreRepository>(
    () => MoreRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<CacheRepository>(
    () => CacheRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<OssLicenseRepository>(
      () => OssLicenseRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<ThemePreferenceRepository>(
      () => ThemePreferenceRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<CustomTabRepository>(
    () => CustomTabRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<UniversitySettingRepository>(
    () => UniversitySettingRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<NotificationSettingRepository>(
    () => NotificationSettingRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(
      sl(),
      getUserSettingValueByNoticeTypeUseCase: sl(),
      getMajorDisplayNameUseCase: sl(),
    ),
  );
  sl.registerLazySingleton<NoticeBoardRemoteDataSource>(
    () => NoticeBoardRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<BookmarkLocalDataSource>(
    () => BookmarkLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<FirebaseRemoteDataSource>(
    () => FirebaseRemoteDataSource(
      messaging: sl(),
      localNotifications: sl(),
      prefsManager: sl(),
    ),
  );
  sl.registerLazySingleton<RecentSearchLocalDataSource>(
    () => RecentSearchLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<SearchLocalDataSource>(
    () => SearchLocalDataSourceImpl(recentSearchManager: sl()),
  );
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<MoreLocalDataSource>(
    () => MoreLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<CacheLocalDataSource>(
    () => CacheLocalDataSourceImpl(sharedPrefsManager: sl()),
  );
  sl.registerLazySingleton<OssLicenseLocalDataSource>(
      () => OssLicenseLocalDataSourceImpl());
  sl.registerLazySingleton<ThemePreferenceLocalDataSource>(
    () => ThemePreferenceLocalDataSourceImpl(sharedPrefsManager: sl()),
  );
  sl.registerLazySingleton<CustomTabLocalDataSource>(
    () => CustomTabLocalDataSourceImpl(prefsManager: sl()),
  );
  sl.registerLazySingleton<UniversitySettingLocalDataSource>(
    () => UniversitySettingLocalDataSourceImpl(prefsManager: sl()),
  );
  sl.registerLazySingleton<NotificationSettingLocalDataSource>(
    () => NotificationSettingLocalDataSourceImpl(prefsManager: sl()),
  );
  sl.registerLazySingleton<NotificationSettingRemoteDataSource>(
    () => NotificationSettingRemoteDataSourceImpl(firebaseDataSource: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => SharedPrefsManager(sl()));

  sl.registerLazySingleton(() => FirebaseMessaging.instance);
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());
}
