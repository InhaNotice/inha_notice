/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/user_preference/data/datasources/user_preference_local_data_source.dart';
import 'package:inha_notice/features/user_preference/domain/entities/user_preference_entity.dart';
import 'package:inha_notice/features/user_preference/domain/failures/user_preference_failure.dart';
import 'package:inha_notice/features/user_preference/domain/repositories/user_preference_repository.dart';

class UserPreferenceRepositoryImpl implements UserPreferenceRepository {
  final UserPreferenceLocalDataSource localDataSource;

  UserPreferenceRepositoryImpl({required this.localDataSource});

  @override
  Either<UserPreferenceFailure, UserPreferenceEntity> getUserPreferences() {
    try {
      final UserPreferenceEntity preferences =
          localDataSource.getUserPreferences();
      return Right(preferences);
    } catch (e) {
      return Left(UserPreferenceFailure.storage(e.toString()));
    }
  }

  @override
  Future<Either<UserPreferenceFailure, UserPreferenceEntity>>
      updateUserPreferences(UserPreferenceEntity preferences) async {
    try {
      await localDataSource.saveUserPreferences(preferences);
      return Right(preferences);
    } catch (e) {
      return Left(UserPreferenceFailure.storage(e.toString()));
    }
  }
}
