/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inha_notice/core/error/failures.dart';

part 'more_failure.freezed.dart';

@freezed
class MoreFailure with _$MoreFailure implements Failures {
  const MoreFailure._();

  const factory MoreFailure.configuration() = _Configuration;

  @override
  String get message => when(configuration: () => '환경변수 로드 실패');

  @override
  List<Object> get props => [message];

  @override
  bool? get stringify => true;
}
