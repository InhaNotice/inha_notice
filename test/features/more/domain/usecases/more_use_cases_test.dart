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
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/more/domain/entities/more_configuration_entity.dart';
import 'package:inha_notice/features/more/domain/entities/oss_license_category_entity.dart';
import 'package:inha_notice/features/more/domain/failures/cache_failure.dart';
import 'package:inha_notice/features/more/domain/failures/more_failure.dart';
import 'package:inha_notice/features/more/domain/failures/oss_license_failure.dart';
import 'package:inha_notice/features/more/domain/failures/theme_preference_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/cache_repository.dart';
import 'package:inha_notice/features/more/domain/repositories/more_repository.dart';
import 'package:inha_notice/features/more/domain/repositories/oss_license_repository.dart';
import 'package:inha_notice/features/more/domain/repositories/theme_preference_repository.dart';
import 'package:inha_notice/features/more/domain/usecases/get_cache_size_use_case.dart';
import 'package:inha_notice/features/more/domain/usecases/get_oss_licenses_use_case.dart';
import 'package:inha_notice/features/more/domain/usecases/get_theme_preference_use_case.dart';
import 'package:inha_notice/features/more/domain/usecases/get_web_urls_use_case.dart';
import 'package:inha_notice/features/more/domain/usecases/set_theme_preference_use_case.dart';

class _FakeMoreRepository implements MoreRepository {
  Either<MoreFailure, MoreConfigurationEntity> result =
      const Left(MoreFailure.configuration());

  @override
  Future<Either<MoreFailure, MoreConfigurationEntity>> getWebUrls() async {
    return result;
  }
}

class _FakeThemePreferenceRepository implements ThemePreferenceRepository {
  Either<ThemePreferenceFailure, ThemeMode> getResult =
      const Left(ThemePreferenceFailure.storage());
  Either<ThemePreferenceFailure, ThemeMode> setResult =
      const Left(ThemePreferenceFailure.storage());
  ThemeMode? lastSetThemeMode;

  @override
  Either<ThemePreferenceFailure, ThemeMode> getThemeMode() {
    return getResult;
  }

  @override
  Future<Either<ThemePreferenceFailure, ThemeMode>> setThemeMode(
      ThemeMode themeMode) async {
    lastSetThemeMode = themeMode;
    return setResult;
  }
}

class _FakeCacheRepository implements CacheRepository {
  Either<CacheFailure, String> result = const Left(CacheFailure.fileSystem());

  @override
  Future<Either<CacheFailure, String>> getCacheSize() async {
    return result;
  }
}

class _FakeOssLicenseRepository implements OssLicenseRepository {
  Either<OssLicenseFailure, List<OssLicenseCategoryEntity>> result =
      const Left(OssLicenseFailure.loadError());

  @override
  Future<Either<OssLicenseFailure, List<OssLicenseCategoryEntity>>>
      getOssLicenses() async {
    return result;
  }
}

void main() {
  group('More UseCase 유닛 테스트', () {
    test('GetWebUrlsUseCase는 저장소 결과를 그대로 반환한다', () async {
      final repository = _FakeMoreRepository()
        ..result = const Right(MoreConfigurationEntity(
          appVersion: '1.0.0',
          featuresUrl: 'https://a.com/features',
          personalInformationUrl: 'https://a.com/privacy',
          termsAndConditionsOfServiceUrl: 'https://a.com/terms',
          introduceAppUrl: 'https://a.com/intro',
          questionsAndAnswersUrl: 'https://a.com/qna',
        ));
      final useCase = GetWebUrlsUseCase(repository: repository);

      final result = await useCase();

      expect(result.isRight(), isTrue);
    });

    test('GetThemePreferenceUseCase는 저장소 테마 값을 그대로 반환한다', () {
      final repository = _FakeThemePreferenceRepository()
        ..getResult = const Right(ThemeMode.dark);
      final useCase = GetThemePreferenceUseCase(repository: repository);

      final result = useCase();

      expect(result, const Right(ThemeMode.dark));
    });

    test('SetThemePreferenceUseCase는 themeMode를 전달한다', () async {
      final repository = _FakeThemePreferenceRepository()
        ..setResult = const Right(ThemeMode.light);
      final useCase = SetThemePreferenceUseCase(repository: repository);

      final result = await useCase(ThemeMode.light);

      expect(repository.lastSetThemeMode, ThemeMode.light);
      expect(result, const Right(ThemeMode.light));
    });

    test('GetCacheSizeUseCase는 저장소 결과를 그대로 반환한다', () async {
      final repository = _FakeCacheRepository()
        ..result = const Right('1.25 MB');
      final useCase = GetCacheSizeUseCase(repository: repository);

      final result = await useCase();

      expect(result, const Right('1.25 MB'));
    });

    test('GetOssLicensesUseCase는 저장소 결과를 그대로 반환한다', () async {
      final repository = _FakeOssLicenseRepository()
        ..result = const Right([
          OssLicenseCategoryEntity(categoryName: 'a', items: []),
        ]);
      final useCase = GetOssLicensesUseCase(repository: repository);

      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Right 이어야 합니다.'),
        (categories) => expect(categories.first.categoryName, 'a'),
      );
    });
  });
}
