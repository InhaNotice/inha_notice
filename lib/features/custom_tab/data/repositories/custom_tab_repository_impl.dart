/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-11
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/custom_tab/data/datasources/custom_tab_local_data_source.dart';
import 'package:inha_notice/features/custom_tab/domain/failures/custom_tab_failure.dart';
import 'package:inha_notice/features/custom_tab/domain/repositories/custom_tab_repository.dart';

class CustomTabRepositoryImpl implements CustomTabRepository {
  final CustomTabLocalDataSource localDataSource;

  CustomTabRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<CustomTabFailure, List<String>>> getSelectedTabs() async {
    try {
      final tabs = localDataSource.getSelectedTabs();
      return Right(tabs);
    } catch (e) {
      return Left(CustomTabFailure.loadTabs(e.toString()));
    }
  }

  @override
  Future<Either<CustomTabFailure, Unit>> saveTabs(List<String> tabs) async {
    try {
      await localDataSource.saveTabs(tabs);
      return const Right(unit);
    } catch (e) {
      return Left(CustomTabFailure.saveTabs(e.toString()));
    }
  }
}
