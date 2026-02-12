/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inha_notice/core/error/failures.dart';

part 'home_failure.freezed.dart';

@freezed
class HomeFailure with _$HomeFailure implements Failures {
  const HomeFailure._();

  const factory HomeFailure.tabs(String message) = _Tabs;

  @override
  String get message => when(tabs: (msg) => msg);

  @override
  List<Object> get props => [message];

  @override
  bool? get stringify => true;
}
