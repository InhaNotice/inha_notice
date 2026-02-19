/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/more/domain/entities/more_configuration_entity.dart';
import 'package:inha_notice/features/more/domain/failures/cache_failure.dart';
import 'package:inha_notice/features/more/domain/failures/more_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/cache_repository.dart';
import 'package:inha_notice/features/more/domain/repositories/more_repository.dart';
import 'package:inha_notice/features/more/domain/usecases/get_cache_size_use_case.dart';
import 'package:inha_notice/features/more/domain/usecases/get_web_urls_use_case.dart';
import 'package:inha_notice/features/more/presentation/bloc/cache_bloc.dart';
import 'package:inha_notice/features/more/presentation/bloc/more_bloc.dart';
import 'package:inha_notice/features/more/presentation/pages/more_page.dart';
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

class _FakeMoreRepository implements MoreRepository {
  Either<MoreFailure, MoreConfigurationEntity> result =
      const Left(MoreFailure.configuration());

  @override
  Future<Either<MoreFailure, MoreConfigurationEntity>> getWebUrls() async {
    return result;
  }
}

class _FakeCacheRepository implements CacheRepository {
  Either<CacheFailure, String> result = const Right('0.00 MB');

  @override
  Future<Either<CacheFailure, String>> getCacheSize() async {
    return result;
  }
}

void main() {
  group('MorePage 위젯 테스트', () {
    late _FakeMoreRepository moreRepository;
    late _FakeCacheRepository cacheRepository;

    setUp(() async {
      await di.sl.reset();

      final prefs = _FakeSharedPrefsManager()
        ..values[SharedPrefKeys.kUserThemeSetting] = '시스템 설정';

      moreRepository = _FakeMoreRepository();
      cacheRepository = _FakeCacheRepository();

      di.sl.registerLazySingleton<SharedPrefsManager>(() => prefs);
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
    });

    tearDown(() async {
      await di.sl.reset();
    });

    testWidgets('로딩 성공 시 주요 섹션과 앱 버전, 캐시 크기를 렌더링한다', (tester) async {
      moreRepository.result = const Right(
        MoreConfigurationEntity(
          appVersion: '1.2.3',
          featuresUrl: 'https://a.com/features',
          personalInformationUrl: 'https://a.com/privacy',
          termsAndConditionsOfServiceUrl: 'https://a.com/terms',
          introduceAppUrl: 'https://a.com/intro',
          questionsAndAnswersUrl: 'https://a.com/faq',
        ),
      );
      cacheRepository.result = const Right('12.34 MB');

      await pumpInhaApp(
        tester,
        child: const MorePage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('공지사항'), findsOneWidget);
      expect(find.text('이용 안내'), findsOneWidget);
      expect(find.text('앱 설정'), findsOneWidget);
      expect(find.text('1.2.3'), findsOneWidget);
      expect(find.text('12.34 MB'), findsOneWidget);
    });

    testWidgets('로딩 실패 시 에러 메시지를 렌더링한다', (tester) async {
      moreRepository.result = const Left(MoreFailure.configuration());

      await pumpInhaApp(
        tester,
        child: const MorePage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('설정 정보를 불러오는데 실패했습니다.'), findsOneWidget);
    });
  });
}
