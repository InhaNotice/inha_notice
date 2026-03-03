/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-03-03
 */

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inha_notice/core/error/failures.dart';

part 'today_fortune_failure.freezed.dart';

@freezed
class TodayFortuneFailure with _$TodayFortuneFailure implements Failures {
  const TodayFortuneFailure._();

  const factory TodayFortuneFailure.storage() = _Storage;
  const factory TodayFortuneFailure.messagePool() = _MessagePool;

  @override
  String get message => when(
        storage: () => '이스터에그 상태 저장 오류',
        messagePool: () => '운세 문구 로드 오류',
      );

  @override
  List<Object> get props => <Object>[message];

  @override
  bool? get stringify => true;
}
