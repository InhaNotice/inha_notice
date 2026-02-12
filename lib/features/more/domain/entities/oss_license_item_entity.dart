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

class OssLicenseItemEntity extends Equatable {
  final String packageName;
  final String licenseText;

  const OssLicenseItemEntity({
    required this.packageName,
    required this.licenseText,
  });

  @override
  List<Object?> get props => [packageName, licenseText];
}
