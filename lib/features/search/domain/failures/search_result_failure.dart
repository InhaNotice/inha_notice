/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inha_notice/core/error/failures.dart';

part 'search_result_failure.freezed.dart';

@freezed
class SearchResultFailure with _$SearchResultFailure implements Failures {
  const SearchResultFailure._();

  const factory SearchResultFailure.network(String message) = _Network;
  const factory SearchResultFailure.unknown(String message) = _Unknown;

  @override
  String get message => when(
        network: (msg) => msg,
        unknown: (msg) => msg,
      );

  @override
  List<Object> get props => [message];

  @override
  bool? get stringify => true;
}
