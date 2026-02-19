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
import 'package:inha_notice/features/university_setting/data/datasources/university_setting_local_data_source.dart';
import 'package:inha_notice/features/university_setting/data/repositories/university_setting_repository_impl.dart';

class _FakeUniversitySettingLocalDataSource
    implements UniversitySettingLocalDataSource {
  String? currentValue;
  Object? getError;
  Object? saveError;
  Object? saveMajorError;

  String? lastSavePrefKey;
  String? lastSaveValue;
  String? lastOldKey;
  String? lastNewKey;
  String? lastMajorKeyType;

  @override
  String? getCurrentSetting(String prefKey) {
    if (getError != null) {
      throw getError!;
    }
    return currentValue;
  }

  @override
  Future<void> saveMajorSetting(
      String? oldKey, String newKey, String majorKeyType) async {
    if (saveMajorError != null) {
      throw saveMajorError!;
    }
    lastOldKey = oldKey;
    lastNewKey = newKey;
    lastMajorKeyType = majorKeyType;
  }

  @override
  Future<void> saveSetting(String prefKey, String value) async {
    if (saveError != null) {
      throw saveError!;
    }
    lastSavePrefKey = prefKey;
    lastSaveValue = value;
  }
}

void main() {
  group('UniversitySettingRepositoryImpl 유닛 테스트', () {
    test('getCurrentSetting 성공 시 Right를 반환한다', () async {
      final local = _FakeUniversitySettingLocalDataSource()
        ..currentValue = 'CSE';
      final repository =
          UniversitySettingRepositoryImpl(localDataSource: local);

      final result = await repository.getCurrentSetting('major-key');

      expect(result, const Right('CSE'));
    });

    test('getCurrentSetting 실패 시 loadSetting Failure를 반환한다', () async {
      final local = _FakeUniversitySettingLocalDataSource()
        ..getError = Exception('read failed');
      final repository =
          UniversitySettingRepositoryImpl(localDataSource: local);

      final result = await repository.getCurrentSetting('major-key');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('read failed')),
        (_) => fail('Left 이어야 합니다.'),
      );
    });

    test('saveSetting 성공 시 Right(unit)를 반환한다', () async {
      final local = _FakeUniversitySettingLocalDataSource();
      final repository =
          UniversitySettingRepositoryImpl(localDataSource: local);

      final result = await repository.saveSetting('college-key', 'SWCC');

      expect(local.lastSavePrefKey, 'college-key');
      expect(local.lastSaveValue, 'SWCC');
      expect(result, const Right(unit));
    });

    test('saveMajorSetting 실패 시 saveSetting Failure를 반환한다', () async {
      final local = _FakeUniversitySettingLocalDataSource()
        ..saveMajorError = Exception('write failed');
      final repository =
          UniversitySettingRepositoryImpl(localDataSource: local);

      final result =
          await repository.saveMajorSetting('MECH', 'CSE', 'major-key');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('write failed')),
        (_) => fail('Left 이어야 합니다.'),
      );
    });
  });
}
