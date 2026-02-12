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

part 'oss_license_failure.freezed.dart';

@freezed
class OssLicenseFailure with _$OssLicenseFailure implements Failures {
  const OssLicenseFailure._();

  const factory OssLicenseFailure.loadError() = _LoadError;

  @override
  String get message => when(loadError: () => '환경변수 로드 실패');

  @override
  List<Object> get props => [message];

  @override
  bool? get stringify => true;
}
