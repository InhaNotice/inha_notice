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
import 'package:inha_notice/features/more/data/datasources/cache_local_data_source.dart';
import 'package:inha_notice/features/more/data/datasources/more_local_data_source.dart';
import 'package:inha_notice/features/more/data/datasources/oss_license_local_data_source.dart';
import 'package:inha_notice/features/more/data/datasources/theme_preference_local_data_source.dart';
import 'package:inha_notice/features/more/data/models/more_configuration_model.dart';
import 'package:inha_notice/features/more/data/models/oss_license_category_model.dart';
import 'package:inha_notice/features/more/data/repositories/cache_repository_impl.dart';
import 'package:inha_notice/features/more/data/repositories/more_repository_impl.dart';
import 'package:inha_notice/features/more/data/repositories/oss_license_repository_impl.dart';
import 'package:inha_notice/features/more/data/repositories/theme_preference_repository_impl.dart';

class _FakeMoreLocalDataSource implements MoreLocalDataSource {
  MoreConfigurationModel result = const MoreConfigurationModel(
    appVersion: '1.0.0',
    featuresUrl: 'https://a.com/features',
    personalInformationUrl: 'https://a.com/privacy',
    termsAndConditionsOfServiceUrl: 'https://a.com/terms',
    introduceAppUrl: 'https://a.com/intro',
    questionsAndAnswersUrl: 'https://a.com/qna',
  );
  Object? error;

  @override
  Future<MoreConfigurationModel> getWebUrls() async {
    if (error != null) {
      throw error!;
    }
    return result;
  }
}

class _FakeThemePreferenceLocalDataSource
    implements ThemePreferenceLocalDataSource {
  ThemeMode getResult = ThemeMode.system;
  Object? getError;
  Object? setError;
  ThemeMode? lastSetThemeMode;

  @override
  ThemeMode getThemeMode() {
    if (getError != null) {
      throw getError!;
    }
    return getResult;
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (setError != null) {
      throw setError!;
    }
    lastSetThemeMode = themeMode;
  }
}

class _FakeCacheLocalDataSource implements CacheLocalDataSource {
  String result = '0.00 MB';
  Object? error;

  @override
  Future<String> getCacheSize() async {
    if (error != null) {
      throw error!;
    }
    return result;
  }
}

class _FakeOssLicenseLocalDataSource implements OssLicenseLocalDataSource {
  List<OssLicenseCategoryModel> result = const [];
  Object? error;

  @override
  Future<List<OssLicenseCategoryModel>> getOssLicenses() async {
    if (error != null) {
      throw error!;
    }
    return result;
  }
}

void main() {
  group('More RepositoryImpl 유닛 테스트', () {
    test('MoreRepositoryImpl.getWebUrls 성공 시 Right를 반환한다', () async {
      final local = _FakeMoreLocalDataSource();
      final repository = MoreRepositoryImpl(localDataSource: local);

      final result = await repository.getWebUrls();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Right 이어야 합니다.'),
        (config) => expect(config.appVersion, '1.0.0'),
      );
    });

    test('MoreRepositoryImpl.getWebUrls 실패 시 configuration Failure를 반환한다',
        () async {
      final local = _FakeMoreLocalDataSource()..error = Exception('env');
      final repository = MoreRepositoryImpl(localDataSource: local);

      final result = await repository.getWebUrls();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, '환경변수 로드 실패'),
        (_) => fail('Left 이어야 합니다.'),
      );
    });

    test('ThemePreferenceRepositoryImpl.getThemeMode 성공 시 Right를 반환한다', () {
      final local = _FakeThemePreferenceLocalDataSource()
        ..getResult = ThemeMode.dark;
      final repository = ThemePreferenceRepositoryImpl(localDataSource: local);

      final result = repository.getThemeMode();

      expect(result, const Right(ThemeMode.dark));
    });

    test(
        'ThemePreferenceRepositoryImpl.setThemeMode 실패 시 storage Failure를 반환한다',
        () async {
      final local = _FakeThemePreferenceLocalDataSource()
        ..setError = Exception('write');
      final repository = ThemePreferenceRepositoryImpl(localDataSource: local);

      final result = await repository.setThemeMode(ThemeMode.light);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, '테마 설정 저장 오류'),
        (_) => fail('Left 이어야 합니다.'),
      );
    });

    test('CacheRepositoryImpl.getCacheSize 실패 시 fileSystem Failure를 반환한다',
        () async {
      final local = _FakeCacheLocalDataSource()..error = Exception('fs');
      final repository = CacheRepositoryImpl(localDataSource: local);

      final result = await repository.getCacheSize();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, '캐시 크기 계산 오류'),
        (_) => fail('Left 이어야 합니다.'),
      );
    });

    test('OssLicenseRepositoryImpl.getOssLicenses 성공 시 Right를 반환한다', () async {
      final local = _FakeOssLicenseLocalDataSource()
        ..result = const [
          OssLicenseCategoryModel(categoryName: 'flutter', items: []),
        ];
      final repository = OssLicenseRepositoryImpl(localDataSource: local);

      final result = await repository.getOssLicenses();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Right 이어야 합니다.'),
        (categories) => expect(categories.first.categoryName, 'flutter'),
      );
    });

    test('OssLicenseRepositoryImpl.getOssLicenses 실패 시 loadError Failure를 반환한다',
        () async {
      final local = _FakeOssLicenseLocalDataSource()..error = Exception('json');
      final repository = OssLicenseRepositoryImpl(localDataSource: local);

      final result = await repository.getOssLicenses();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, '환경변수 로드 실패'),
        (_) => fail('Left 이어야 합니다.'),
      );
    });
  });
}
