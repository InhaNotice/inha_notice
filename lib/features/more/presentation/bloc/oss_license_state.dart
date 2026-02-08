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
import 'package:inha_notice/features/more/domain/entities/oss_license_category_entity.dart';

abstract class OssLicenseState extends Equatable {
  const OssLicenseState();

  @override
  List<Object> get props => [];
}

class OssLicenseInitial extends OssLicenseState {}

class OssLicenseLoading extends OssLicenseState {}

class OssLicenseLoaded extends OssLicenseState {
  final List<OssLicenseCategoryEntity> licenses;

  const OssLicenseLoaded(this.licenses);

  @override
  List<Object> get props => [licenses];
}

class OssLicenseError extends OssLicenseState {
  final String message;

  const OssLicenseError({required this.message});

  @override
  List<Object> get props => [message];
}
