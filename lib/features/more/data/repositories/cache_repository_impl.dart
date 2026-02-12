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
import 'package:inha_notice/features/more/data/datasources/cache_local_data_source.dart';
import 'package:inha_notice/features/more/domain/failures/cache_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/cache_repository.dart';

class CacheRepositoryImpl implements CacheRepository {
  final CacheLocalDataSource localDataSource;

  CacheRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<CacheFailure, String>> getCacheSize() async {
    try {
      final String result = await localDataSource.getCacheSize();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure.fileSystem());
    }
  }
}
