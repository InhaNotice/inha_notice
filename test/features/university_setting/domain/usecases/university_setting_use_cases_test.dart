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
import 'package:inha_notice/features/university_setting/domain/failures/university_setting_failure.dart';
import 'package:inha_notice/features/university_setting/domain/repositories/university_setting_repository.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/get_current_setting_use_case.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/save_major_setting_use_case.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/save_setting_use_case.dart';

class _FakeUniversitySettingRepository implements UniversitySettingRepository {
  Either<UniversitySettingFailure, String?> getResult = const Right(null);
  Either<UniversitySettingFailure, Unit> saveResult = const Right(unit);
  Either<UniversitySettingFailure, Unit> saveMajorResult = const Right(unit);

  String? lastGetPrefKey;
  String? lastSavePrefKey;
  String? lastSaveValue;
  String? lastOldKey;
  String? lastNewKey;
  String? lastMajorKeyType;

  @override
  Future<Either<UniversitySettingFailure, String?>> getCurrentSetting(
      String prefKey) async {
    lastGetPrefKey = prefKey;
    return getResult;
  }

  @override
  Future<Either<UniversitySettingFailure, Unit>> saveMajorSetting(
      String? oldKey, String newKey, String majorKeyType) async {
    lastOldKey = oldKey;
    lastNewKey = newKey;
    lastMajorKeyType = majorKeyType;
    return saveMajorResult;
  }

  @override
  Future<Either<UniversitySettingFailure, Unit>> saveSetting(
      String prefKey, String value) async {
    lastSavePrefKey = prefKey;
    lastSaveValue = value;
    return saveResult;
  }
}

void main() {
  group('UniversitySetting UseCase 유닛 테스트', () {
    test('GetCurrentSettingUseCase는 prefKey를 전달한다', () async {
      final repository = _FakeUniversitySettingRepository()
        ..getResult = const Right('CSE');
      final useCase = GetCurrentSettingUseCase(repository: repository);

      final result = await useCase(prefKey: 'major-key');

      expect(repository.lastGetPrefKey, 'major-key');
      expect(result, const Right('CSE'));
    });

    test('SaveSettingUseCase는 prefKey/value를 전달한다', () async {
      final repository = _FakeUniversitySettingRepository();
      final useCase = SaveSettingUseCase(repository: repository);

      final result = await useCase(prefKey: 'college-key', value: 'SWCC');

      expect(repository.lastSavePrefKey, 'college-key');
      expect(repository.lastSaveValue, 'SWCC');
      expect(result, const Right(unit));
    });

    test('SaveMajorSettingUseCase는 old/new/majorKeyType을 전달한다', () async {
      final repository = _FakeUniversitySettingRepository();
      final useCase = SaveMajorSettingUseCase(repository: repository);

      final result = await useCase(
        oldKey: 'MECH',
        newKey: 'CSE',
        majorKeyType: 'major-key',
      );

      expect(repository.lastOldKey, 'MECH');
      expect(repository.lastNewKey, 'CSE');
      expect(repository.lastMajorKeyType, 'major-key');
      expect(result, const Right(unit));
    });
  });
}
