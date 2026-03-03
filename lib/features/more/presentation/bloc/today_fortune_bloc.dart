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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/more/domain/entities/today_fortune_entity.dart';
import 'package:inha_notice/features/more/domain/failures/today_fortune_failure.dart';
import 'package:inha_notice/features/more/domain/usecases/get_today_fortune_use_case.dart';
import 'package:inha_notice/features/more/domain/usecases/increment_today_fortune_tap_count_use_case.dart';
import 'package:inha_notice/features/more/domain/usecases/reset_today_fortune_tap_count_use_case.dart';
import 'package:inha_notice/features/more/presentation/bloc/today_fortune_event.dart';
import 'package:inha_notice/features/more/presentation/bloc/today_fortune_state.dart';

class TodayFortuneBloc extends Bloc<TodayFortuneEvent, TodayFortuneState> {
  final IncrementTodayFortuneTapCountUseCase incrementTapCountUseCase;
  final ResetTodayFortuneTapCountUseCase resetTapCountUseCase;
  final GetTodayFortuneUseCase getTodayFortuneUseCase;
  static const int _kThreshold = 10;
  static const int _kCooldownMs = 1500;
  bool _isCooldown = false;

  TodayFortuneBloc({
    required this.incrementTapCountUseCase,
    required this.resetTapCountUseCase,
    required this.getTodayFortuneUseCase,
  }) : super(TodayFortuneInitial()) {
    on<VersionTileTappedEvent>(_onVersionTileTapped);
    on<TodayFortuneRerolledEvent>(_onTodayFortuneRerolled);
    on<TodayFortuneSheetClosedEvent>(_onTodayFortuneSheetClosed);
  }

  Future<void> _onVersionTileTapped(
    VersionTileTappedEvent event,
    Emitter<TodayFortuneState> emit,
  ) async {
    if (_isCooldown) {
      return;
    }

    final Either<TodayFortuneFailure, int> tapResult =
        await incrementTapCountUseCase();

    await tapResult.fold(
      (TodayFortuneFailure failure) async {
        emit(TodayFortuneError(message: failure.message));
      },
      (int tapCount) async {
        if (tapCount < _kThreshold) {
          emit(TodayFortuneCounting(tapCount: tapCount));
          return;
        }

        final Either<TodayFortuneFailure, void> resetResult =
            await resetTapCountUseCase();
        final bool isResetFailed = resetResult.isLeft();
        if (isResetFailed) {
          emit(
            TodayFortuneError(
              message: const TodayFortuneFailure.storage().message,
            ),
          );
          return;
        }

        final Either<TodayFortuneFailure, TodayFortuneEntity> fortuneResult =
            await getTodayFortuneUseCase();

        fortuneResult.fold(
          (TodayFortuneFailure failure) =>
              emit(TodayFortuneError(message: failure.message)),
          (TodayFortuneEntity fortune) =>
              emit(TodayFortuneReady(fortune: fortune, tapCount: tapCount)),
        );
      },
    );
  }

  Future<void> _onTodayFortuneRerolled(
    TodayFortuneRerolledEvent event,
    Emitter<TodayFortuneState> emit,
  ) async {
    final Either<TodayFortuneFailure, TodayFortuneEntity> result =
        await getTodayFortuneUseCase();

    result.fold(
      (TodayFortuneFailure failure) =>
          emit(TodayFortuneError(message: failure.message)),
      (TodayFortuneEntity fortune) =>
          emit(TodayFortuneReady(fortune: fortune, tapCount: _kThreshold)),
    );
  }

  Future<void> _onTodayFortuneSheetClosed(
    TodayFortuneSheetClosedEvent event,
    Emitter<TodayFortuneState> emit,
  ) async {
    _isCooldown = true;
    emit(const TodayFortuneCooldown(remainingMs: _kCooldownMs));
    await Future<void>.delayed(const Duration(milliseconds: _kCooldownMs));
    _isCooldown = false;
    emit(TodayFortuneInitial());
  }
}
