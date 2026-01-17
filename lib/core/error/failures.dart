/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'package:equatable/equatable.dart';

export 'package:inha_notice/features/notice/domain/failures/home_failure.dart';

abstract class Failures extends Equatable {
  final String message;

  const Failures(this.message);

  @override
  List<Object> get props => [message];
}
