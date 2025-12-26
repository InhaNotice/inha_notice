import 'package:get_it/get_it.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';

import 'features/notice/data/datasources/home_local_data_source.dart';
import 'features/notice/data/repositories/home_repository_impl.dart';
import 'features/notice/domain/repositories/home_repository.dart';
import 'features/notice/domain/usecases/get_home_tabs_usecase.dart';
import 'features/notice/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => HomeBloc(getHomeTabsUsecase: sl()),
  );

  sl.registerLazySingleton(() => GetHomeTabsUseCase(sl()));

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton(() => SharedPrefsManager());
}
