/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-18
 */

import 'package:get_it/get_it.dart';
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

  // UseCase
  sl.registerLazySingleton(() => GetHomeTabsUseCase(sl()));
  sl.registerLazySingleton(() => GetBookmarksUseCase(repository: sl()));
  sl.registerLazySingleton(() => ClearBookmarksUseCase(repository: sl()));
  sl.registerLazySingleton(() => RemoveBookmarkUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(localDataSource: sl()),
  );

  // Datasources
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<BookmarkLocalDataSource>(
    () => BookmarkLocalDataSourceImpl(),
  );

  // External
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => SharedPrefsManager());
}
