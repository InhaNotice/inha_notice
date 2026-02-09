/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-09
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/more/domain/entities/more_configuration_entity.dart';
import 'package:inha_notice/features/more/domain/failures/more_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/more_repository.dart';

class GetWebUrlsUseCase {
  final MoreRepository repository;

  const GetWebUrlsUseCase({required this.repository});

  Future<Either<MoreFailure, MoreConfigurationEntity>> call() async {
    return await repository.getWebUrls();
  }
}
