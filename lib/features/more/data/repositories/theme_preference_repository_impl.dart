/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-11
 */

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:inha_notice/features/more/data/datasources/theme_preference_local_data_source.dart';
import 'package:inha_notice/features/more/domain/failures/theme_preference_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/theme_preference_repository.dart';

class ThemePreferenceRepositoryImpl implements ThemePreferenceRepository {
  final ThemePreferenceLocalDataSource localDataSource;

  ThemePreferenceRepositoryImpl({required this.localDataSource});

  @override
  Either<ThemePreferenceFailure, ThemeMode> getThemeMode() {
    try {
      final ThemeMode result = localDataSource.getThemeMode();
      return Right(result);
    } catch (e) {
      return Left(ThemePreferenceFailure.storage());
    }
  }

  @override
  Future<Either<ThemePreferenceFailure, ThemeMode>> setThemeMode(
      ThemeMode themeMode) async {
    try {
      await localDataSource.setThemeMode(themeMode);
      return Right(themeMode);
    } catch (e) {
      return Left(ThemePreferenceFailure.storage());
    }
  }
}
