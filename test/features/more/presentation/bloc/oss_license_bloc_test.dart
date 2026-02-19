/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/more/domain/entities/oss_license_category_entity.dart';
import 'package:inha_notice/features/more/domain/failures/oss_license_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/oss_license_repository.dart';
import 'package:inha_notice/features/more/domain/usecases/get_oss_licenses_use_case.dart';
import 'package:inha_notice/features/more/presentation/bloc/oss_license_bloc.dart';
import 'package:inha_notice/features/more/presentation/bloc/oss_license_event.dart';
import 'package:inha_notice/features/more/presentation/bloc/oss_license_state.dart';

class _FakeOssLicenseRepository implements OssLicenseRepository {
  Either<OssLicenseFailure, List<OssLicenseCategoryEntity>> result =
      const Right([]);

  @override
  Future<Either<OssLicenseFailure, List<OssLicenseCategoryEntity>>>
      getOssLicenses() async {
    return result;
  }
}

Future<void> _flushEvents([int times = 20]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('OssLicenseBloc 유닛 테스트', () {
    late _FakeOssLicenseRepository repository;
    late OssLicenseBloc bloc;

    setUp(() {
      repository = _FakeOssLicenseRepository();
      bloc = OssLicenseBloc(
        getOssLicensesUseCase: GetOssLicensesUseCase(repository: repository),
      );
    });

    tearDown(() async {
      await bloc.close();
    });

    test('LoadOssLicensesEvent 성공 시 Loading 후 Loaded 상태가 된다', () async {
      repository.result = const Right([
        OssLicenseCategoryEntity(categoryName: 'flutter', items: []),
      ]);

      bloc.add(LoadOssLicensesEvent());
      await _flushEvents();

      expect(bloc.state, isA<OssLicenseLoaded>());
      final loaded = bloc.state as OssLicenseLoaded;
      expect(loaded.licenses.first.categoryName, 'flutter');
    });

    test('LoadOssLicensesEvent 실패 시 Loading 후 Error 상태가 된다', () async {
      repository.result = const Left(OssLicenseFailure.loadError());

      bloc.add(LoadOssLicensesEvent());
      await _flushEvents();

      expect(
        bloc.state,
        const OssLicenseError(message: '라이선스 파일을 불러오는데 실패했습니다.'),
      );
    });
  });
}
