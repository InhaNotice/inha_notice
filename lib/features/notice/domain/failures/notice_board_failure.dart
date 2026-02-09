/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-09
 */

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inha_notice/core/error/failures.dart';

part 'notice_board_failure.freezed.dart';

@freezed
class NoticeBoardFailure with _$NoticeBoardFailure implements Failures {
  const NoticeBoardFailure._();

  const factory NoticeBoardFailure.fetchNotices(String message) = _FetchNotices;
  const factory NoticeBoardFailure.initScraper(String message) = _InitScraper;

  @override
  String get message => when(
        fetchNotices: (msg) => msg,
        initScraper: (msg) => msg,
      );

  @override
  List<Object> get props => [message];

  @override
  bool? get stringify => true;
}
