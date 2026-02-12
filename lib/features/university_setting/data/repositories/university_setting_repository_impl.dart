/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/university_setting/data/datasources/university_setting_local_data_source.dart';
import 'package:inha_notice/features/university_setting/domain/failures/university_setting_failure.dart';
import 'package:inha_notice/features/university_setting/domain/repositories/university_setting_repository.dart';

class UniversitySettingRepositoryImpl implements UniversitySettingRepository {
  final UniversitySettingLocalDataSource localDataSource;

  UniversitySettingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<UniversitySettingFailure, String?>> getCurrentSetting(
      String prefKey) async {
    try {
      final result = localDataSource.getCurrentSetting(prefKey);
      return Right(result);
    } catch (e) {
      return Left(UniversitySettingFailure.loadSetting(e.toString()));
    }
  }

  @override
  Future<Either<UniversitySettingFailure, Unit>> saveSetting(
      String prefKey, String value) async {
    try {
      await localDataSource.saveSetting(prefKey, value);
      return const Right(unit);
    } catch (e) {
      return Left(UniversitySettingFailure.saveSetting(e.toString()));
    }
  }

  @override
  Future<Either<UniversitySettingFailure, Unit>> saveMajorSetting(
      String? oldKey, String newKey, String majorKeyType) async {
    try {
      await localDataSource.saveMajorSetting(oldKey, newKey, majorKeyType);
      return const Right(unit);
    } catch (e) {
      return Left(UniversitySettingFailure.saveSetting(e.toString()));
    }
  }
}
