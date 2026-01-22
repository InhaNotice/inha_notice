/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-22
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/more/data/datasources/more_local_data_source.dart';
import 'package:inha_notice/features/more/domain/entities/more_configuration_entity.dart';
import 'package:inha_notice/features/more/domain/failures/more_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/more_repository.dart';

class MoreRepositoryImpl implements MoreRepository {
  final MoreLocalDataSource localDataSource;

  MoreRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<MoreFailure, MoreConfigurationEntity>> getWebUrls() async {
    try {
      final MoreConfigurationEntity result = await localDataSource.getWebUrls();
      return Right(result);
    } catch (e) {
      return Left(MoreFailure.configuration());
    }
  }
}
