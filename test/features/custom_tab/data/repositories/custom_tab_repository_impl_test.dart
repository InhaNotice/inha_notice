/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/custom_tab/data/datasources/custom_tab_local_data_source.dart';
import 'package:inha_notice/features/custom_tab/data/repositories/custom_tab_repository_impl.dart';

class _FakeCustomTabLocalDataSource implements CustomTabLocalDataSource {
  List<String> selectedTabs = ['학사'];
  Object? getError;
  Object? saveError;
  List<String>? savedTabs;

  @override
  List<String> getSelectedTabs() {
    if (getError != null) {
      throw getError!;
    }
    return List.from(selectedTabs);
  }

  @override
  Future<void> saveTabs(List<String> tabs) async {
    if (saveError != null) {
      throw saveError!;
    }
    savedTabs = List.from(tabs);
  }
}

void main() {
  group('CustomTabRepositoryImpl 유닛 테스트', () {
    test('getSelectedTabs 성공 시 Right를 반환한다', () async {
      final dataSource = _FakeCustomTabLocalDataSource()
        ..selectedTabs = ['학사', '장학'];
      final repository = CustomTabRepositoryImpl(localDataSource: dataSource);

      final result = await repository.getSelectedTabs();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Right 이어야 합니다.'),
        (tabs) => expect(tabs, ['학사', '장학']),
      );
    });

    test('getSelectedTabs 실패 시 loadTabs Failure를 반환한다', () async {
      final dataSource = _FakeCustomTabLocalDataSource()
        ..getError = Exception('read failed');
      final repository = CustomTabRepositoryImpl(localDataSource: dataSource);

      final result = await repository.getSelectedTabs();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, 'Exception: read failed'),
        (_) => fail('Left 이어야 합니다.'),
      );
    });

    test('saveTabs 성공 시 Right(unit)를 반환한다', () async {
      final dataSource = _FakeCustomTabLocalDataSource();
      final repository = CustomTabRepositoryImpl(localDataSource: dataSource);

      final result = await repository.saveTabs(['학사', '정석']);

      expect(dataSource.savedTabs, ['학사', '정석']);
      expect(result.isRight(), isTrue);
    });

    test('saveTabs 실패 시 saveTabs Failure를 반환한다', () async {
      final dataSource = _FakeCustomTabLocalDataSource()
        ..saveError = Exception('write failed');
      final repository = CustomTabRepositoryImpl(localDataSource: dataSource);

      final result = await repository.saveTabs(['학사']);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, 'Exception: write failed'),
        (_) => fail('Left 이어야 합니다.'),
      );
    });
  });
}
