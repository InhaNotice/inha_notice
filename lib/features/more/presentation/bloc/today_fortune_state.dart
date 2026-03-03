/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-03-03
 */

import 'package:equatable/equatable.dart';
import 'package:inha_notice/features/more/domain/entities/today_fortune_entity.dart';

abstract class TodayFortuneState extends Equatable {
  const TodayFortuneState();

  @override
  List<Object?> get props => <Object?>[];
}

class TodayFortuneInitial extends TodayFortuneState {}

class TodayFortuneCounting extends TodayFortuneState {
  final int tapCount;

  const TodayFortuneCounting({required this.tapCount});

  @override
  List<Object?> get props => <Object?>[tapCount];
}

class TodayFortuneReady extends TodayFortuneState {
  final TodayFortuneEntity fortune;
  final int tapCount;

  const TodayFortuneReady({required this.fortune, required this.tapCount});

  @override
  List<Object?> get props => <Object?>[fortune, tapCount];
}

class TodayFortuneCooldown extends TodayFortuneState {
  final int remainingMs;

  const TodayFortuneCooldown({required this.remainingMs});

  @override
  List<Object?> get props => <Object?>[remainingMs];
}

class TodayFortuneError extends TodayFortuneState {
  final String message;

  const TodayFortuneError({required this.message});

  @override
  List<Object?> get props => <Object?>[message];
}
