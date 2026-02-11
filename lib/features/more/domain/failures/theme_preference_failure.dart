/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-11
 */

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inha_notice/core/error/failures.dart';

part 'theme_preference_failure.freezed.dart';

@freezed
class ThemePreferenceFailure with _$ThemePreferenceFailure implements Failures {
  const ThemePreferenceFailure._();

  const factory ThemePreferenceFailure.storage() = _Storage;

  @override
  String get message => when(storage: () => '테마 설정 저장 오류');

  @override
  List<Object> get props => [message];

  @override
  bool? get stringify => true;
}
