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

class TodayFortuneEntity extends Equatable {
  final String emotionMessage;
  final String actionMessage;

  const TodayFortuneEntity({
    required this.emotionMessage,
    required this.actionMessage,
  });

  @override
  List<Object?> get props => <Object?>[emotionMessage, actionMessage];
}
