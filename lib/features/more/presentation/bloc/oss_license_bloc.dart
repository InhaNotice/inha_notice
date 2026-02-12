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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/more/domain/entities/oss_license_category_entity.dart';
import 'package:inha_notice/features/more/domain/failures/oss_license_failure.dart';
import 'package:inha_notice/features/more/domain/usecases/get_oss_licenses_use_case.dart';

import 'oss_license_event.dart';
import 'oss_license_state.dart';

class OssLicenseBloc extends Bloc<OssLicenseEvent, OssLicenseState> {
  final GetOssLicensesUseCase getOssLicensesUseCase;

  OssLicenseBloc({required this.getOssLicensesUseCase})
      : super(OssLicenseInitial()) {
    on<LoadOssLicensesEvent>(_onLoadOssLicenses);
  }

  Future<void> _onLoadOssLicenses(
    LoadOssLicensesEvent event,
    Emitter<OssLicenseState> emit,
  ) async {
    emit(OssLicenseLoading());

    final Either<OssLicenseFailure, List<OssLicenseCategoryEntity>> result =
        await getOssLicensesUseCase();

    result.fold(
      (failure) => emit(OssLicenseError(message: '라이선스 파일을 불러오는데 실패했습니다.')),
      (licenses) => emit(OssLicenseLoaded(licenses)),
    );
  }
}
