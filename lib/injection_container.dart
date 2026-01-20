/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-20
 */

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:inha_notice/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:inha_notice/features/notification/domain/repositories/notification_repository.dart';
import 'package:inha_notice/features/notification/domain/usecases/request_initial_permission_usecase.dart';
import 'package:inha_notice/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'features/bookmark/domain/repositories/bookmark_repository.dart';
import 'features/bookmark/domain/usecases/clear_bookmarks_use_case.dart';
import 'features/bookmark/domain/usecases/get_bookmarks_use_case.dart';
import 'features/bookmark/domain/usecases/remove_bookmark_use_case.dart';
import 'features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'features/notice/data/datasources/home_local_data_source.dart';
import 'features/notice/data/repositories/home_repository_impl.dart';
import 'features/notice/domain/repositories/home_repository.dart';
import 'features/notice/domain/usecases/get_home_tabs_usecase.dart';
import 'features/notice/presentation/bloc/home_bloc.dart';
import 'features/notification/data/datasources/firebase_remote_data_source.dart';
import 'features/search/data/datasources/search_local_data_source.dart';
import 'features/search/data/datasources/search_remote_data_source.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/domain/repositories/search_repository.dart';
import 'features/search/domain/usecases/add_recent_search_word_usecase.dart';
import 'features/search/domain/usecases/clear_recent_search_words_usecase.dart';
import 'features/search/domain/usecases/get_recent_search_words_usecase.dart';
import 'features/search/domain/usecases/get_trending_topics_usecase.dart';
import 'features/search/domain/usecases/remove_recent_search_word_usecase.dart';
import 'features/search/presentation/bloc/search_bloc.dart';

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

  // UseCase
  sl.registerLazySingleton(() => GetHomeTabsUseCase(sl()));
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

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(localDataSource: sl()),
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

  // Datasources
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(sl()),
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
  sl.registerLazySingleton<SearchLocalDataSource>(
    () => SearchLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => SharedPrefsManager(sl()));

  sl.registerLazySingleton(() => FirebaseMessaging.instance);
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());
}
