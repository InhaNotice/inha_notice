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
import 'package:inha_notice/features/more/domain/entities/today_fortune_entity.dart';
import 'package:inha_notice/features/more/domain/failures/today_fortune_failure.dart';

abstract class TodayFortuneRepository {
  Future<Either<TodayFortuneFailure, int>> incrementVersionTapCount();

  Future<Either<TodayFortuneFailure, void>> resetVersionTapCount();

  Future<Either<TodayFortuneFailure, TodayFortuneEntity>> getRandomFortune();
}
