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
import 'package:flutter/material.dart';
import 'package:inha_notice/features/more/domain/failures/theme_preference_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/theme_preference_repository.dart';

class GetThemePreferenceUseCase {
  final ThemePreferenceRepository repository;

  GetThemePreferenceUseCase({required this.repository});

  Either<ThemePreferenceFailure, ThemeMode> call() {
    return repository.getThemeMode();
  }
}
