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
import 'package:inha_notice/features/user_preference/domain/entities/user_preference_entity.dart';
import 'package:inha_notice/features/user_preference/domain/failures/user_preference_failure.dart';
import 'package:inha_notice/features/user_preference/domain/repositories/user_preference_repository.dart';

class UpdateUserPreferenceUseCase {
  final UserPreferenceRepository repository;

  UpdateUserPreferenceUseCase({required this.repository});

  Future<Either<UserPreferenceFailure, UserPreferenceEntity>> call(
    UserPreferenceEntity preferences,
  ) async {
    return await repository.updateUserPreferences(preferences);
  }
}
