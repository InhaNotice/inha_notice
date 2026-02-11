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

part 'custom_tab_failure.freezed.dart';

@freezed
class CustomTabFailure with _$CustomTabFailure implements Failures {
  const CustomTabFailure._();

  const factory CustomTabFailure.loadTabs(String message) = _LoadTabs;
  const factory CustomTabFailure.saveTabs(String message) = _SaveTabs;

  @override
  String get message => when(
        loadTabs: (msg) => msg,
        saveTabs: (msg) => msg,
      );

  @override
  List<Object> get props => [message];

  @override
  bool? get stringify => true;
}
