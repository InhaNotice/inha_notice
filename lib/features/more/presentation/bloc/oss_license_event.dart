/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-08
 */

import 'package:equatable/equatable.dart';

abstract class OssLicenseEvent extends Equatable {
  const OssLicenseEvent();

  @override
  List<Object> get props => [];
}

class LoadOssLicensesEvent extends OssLicenseEvent {}
