/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:equatable/equatable.dart';

import 'oss_license_item_entity.dart';

class OssLicenseCategoryEntity extends Equatable {
  final String categoryName;
  final List<OssLicenseItemEntity> items;

  const OssLicenseCategoryEntity({
    required this.categoryName,
    required this.items,
  });

  @override
  List<Object?> get props => [categoryName, items];
}
