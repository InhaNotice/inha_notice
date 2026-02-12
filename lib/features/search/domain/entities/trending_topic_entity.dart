/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:equatable/equatable.dart';

class TrendingTopicEntity extends Equatable {
  final String id;
  final String queryCount;
  final String count;
  final String updown;
  final String text;
  final String makeTimes;

  const TrendingTopicEntity(
      {required this.id,
      required this.queryCount,
      required this.count,
      required this.updown,
      required this.text,
      required this.makeTimes});

  @override
  List<Object?> get props => [id, queryCount, count, updown, text, makeTimes];
}
