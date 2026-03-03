/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-03-03
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/more/data/datasources/today_fortune_local_data_source.dart';
import 'package:inha_notice/features/more/domain/entities/today_fortune_entity.dart';
import 'package:inha_notice/features/more/domain/failures/today_fortune_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/today_fortune_repository.dart';

class TodayFortuneRepositoryImpl implements TodayFortuneRepository {
  final TodayFortuneLocalDataSource localDataSource;

  const TodayFortuneRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<TodayFortuneFailure, int>> incrementVersionTapCount() async {
    try {
      final int count = await localDataSource.incrementVersionTapCount();
      return Right(count);
    } catch (_) {
      return const Left(TodayFortuneFailure.storage());
    }
  }

  @override
  Future<Either<TodayFortuneFailure, void>> resetVersionTapCount() async {
    try {
      await localDataSource.resetVersionTapCount();
      return const Right(null);
    } catch (_) {
      return const Left(TodayFortuneFailure.storage());
    }
  }

  @override
  Future<Either<TodayFortuneFailure, TodayFortuneEntity>>
      getRandomFortune() async {
    try {
      final TodayFortuneEntity fortune = localDataSource.getRandomFortune();
      return Right(fortune);
    } catch (_) {
      return const Left(TodayFortuneFailure.messagePool());
    }
  }
}
