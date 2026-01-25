/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-25
 */

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inha_notice/core/error/failures.dart';

part 'cache_failure.freezed.dart';

@freezed
class CacheFailure with _$CacheFailure implements Failures {
  const CacheFailure._();

  const factory CacheFailure.fileSystem() = _FileSystem;

  @override
  String get message => when(fileSystem: () => '캐시 크기 계산 오류');

  @override
  List<Object> get props => [message];

  @override
  bool? get stringify => true;
}
