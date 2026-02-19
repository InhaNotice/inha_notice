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
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/custom_tab/data/datasources/custom_tab_local_data_source.dart';
import 'package:inha_notice/features/custom_tab/domain/entities/custom_tab_policy.dart';

import '../../../../support/unit_test_bootstrap.dart';

void main() {
  ensureTestBinding();

  group('CustomTabLocalDataSourceImpl 유닛 테스트', () {
    setUp(() async {
      await resetMockPrefs();
    });

    test('저장된 탭이 없으면 기본 탭 목록을 반환한다', () async {
      final prefs = await seedMockPrefs({
        SharedPrefKeys.kCustomTabList: <String>[],
      });
      final manager = SharedPrefsManager(prefs);
      await manager.loadPreferences();
      final dataSource = CustomTabLocalDataSourceImpl(prefsManager: manager);

      final result = dataSource.getSelectedTabs();

      expect(result, CustomTabPolicy.kDefaultTabs);
    });

    test('저장된 탭이 있으면 해당 목록을 반환한다', () async {
      final prefs = await seedMockPrefs({
        SharedPrefKeys.kCustomTabList: ['학사', '장학'],
      });
      final manager = SharedPrefsManager(prefs);
      await manager.loadPreferences();
      final dataSource = CustomTabLocalDataSourceImpl(prefsManager: manager);

      final result = dataSource.getSelectedTabs();

      expect(result, ['학사', '장학']);
    });

    test('saveTabs는 커스텀 탭 목록을 저장한다', () async {
      final prefs = await seedMockPrefs({
        SharedPrefKeys.kCustomTabList: <String>[],
      });
      final manager = SharedPrefsManager(prefs);
      await manager.loadPreferences();
      final dataSource = CustomTabLocalDataSourceImpl(prefsManager: manager);

      await dataSource.saveTabs(['학과', '정석']);

      expect(
        manager.getValue<List<String>>(SharedPrefKeys.kCustomTabList),
        ['학과', '정석'],
      );
      expect(
        prefs.getStringList(SharedPrefKeys.kCustomTabList),
        ['학과', '정석'],
      );
    });
  });
}
