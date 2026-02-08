/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-08
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/more/domain/entities/oss_license_category_entity.dart';
import 'package:inha_notice/features/more/domain/failures/oss_license_failure.dart';

abstract class OssLicenseRepository {
  Future<Either<OssLicenseFailure, List<OssLicenseCategoryEntity>>>
      getOssLicenses();
}
