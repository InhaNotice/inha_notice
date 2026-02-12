/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/more/data/datasources/oss_license_local_data_source.dart';
import 'package:inha_notice/features/more/domain/entities/oss_license_category_entity.dart';
import 'package:inha_notice/features/more/domain/failures/oss_license_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/oss_license_repository.dart';

class OssLicenseRepositoryImpl implements OssLicenseRepository {
  final OssLicenseLocalDataSource localDataSource;

  OssLicenseRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<OssLicenseFailure, List<OssLicenseCategoryEntity>>>
      getOssLicenses() async {
    try {
      final List<OssLicenseCategoryEntity> result =
          await localDataSource.getOssLicenses();
      return Right(result);
    } catch (e) {
      return Left(OssLicenseFailure.loadError());
    }
  }
}
