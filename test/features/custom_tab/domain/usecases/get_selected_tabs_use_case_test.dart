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
import 'package:inha_notice/features/custom_tab/domain/failures/custom_tab_failure.dart';
import 'package:inha_notice/features/custom_tab/domain/repositories/custom_tab_repository.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_selected_tabs_use_case.dart';

class _FakeCustomTabRepository implements CustomTabRepository {
  Either<CustomTabFailure, List<String>> getSelectedTabsResult =
      const Right(['학사', '학과']);
  Either<CustomTabFailure, Unit> saveTabsResult = const Right(unit);

  @override
  Future<Either<CustomTabFailure, List<String>>> getSelectedTabs() async {
    return getSelectedTabsResult;
  }

  @override
  Future<Either<CustomTabFailure, Unit>> saveTabs(List<String> tabs) async {
    return saveTabsResult;
  }
}

void main() {
  group('GetSelectedTabsUseCase 유닛 테스트', () {
    test('저장소 성공 결과를 그대로 반환한다', () async {
      final repository = _FakeCustomTabRepository();
      final useCase = GetSelectedTabsUseCase(repository: repository);

      final result = await useCase();

      expect(result, const Right(['학사', '학과']));
    });

    test('저장소 실패 결과를 그대로 반환한다', () async {
      final repository = _FakeCustomTabRepository()
        ..getSelectedTabsResult =
            const Left(CustomTabFailure.loadTabs('불러오기 실패'));
      final useCase = GetSelectedTabsUseCase(repository: repository);

      final result = await useCase();

      expect(result, const Left(CustomTabFailure.loadTabs('불러오기 실패')));
    });
  });
}
