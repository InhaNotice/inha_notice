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
import 'package:inha_notice/features/more/domain/failures/today_fortune_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/today_fortune_repository.dart';

class IncrementTodayFortuneTapCountUseCase {
  final TodayFortuneRepository repository;

  IncrementTodayFortuneTapCountUseCase({required this.repository});

  Future<Either<TodayFortuneFailure, int>> call() {
    return repository.incrementVersionTapCount();
  }
}
