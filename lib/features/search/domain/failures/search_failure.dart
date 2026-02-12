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

part 'search_failure.freezed.dart';

@freezed
class SearchFailure with _$SearchFailure implements Failures {
  const SearchFailure._();

  const factory SearchFailure.localDatabase() = _LocalDatabase;
  const factory SearchFailure.server() = _Server;

  @override
  String get message =>
      when(localDatabase: () => '로컬 데이터베이스 오류', server: () => 'API 서버 연결 실패');

  @override
  List<Object> get props => [message];

  @override
  bool? get stringify => true;
}
