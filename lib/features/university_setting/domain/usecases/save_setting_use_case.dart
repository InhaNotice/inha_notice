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
import 'package:inha_notice/features/university_setting/domain/failures/university_setting_failure.dart';
import 'package:inha_notice/features/university_setting/domain/repositories/university_setting_repository.dart';

class SaveSettingUseCase {
  final UniversitySettingRepository repository;

  SaveSettingUseCase({required this.repository});

  Future<Either<UniversitySettingFailure, Unit>> call(
      {required String prefKey, required String value}) async {
    return await repository.saveSetting(prefKey, value);
  }
}
