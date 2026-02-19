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
import 'package:inha_notice/features/custom_tab/domain/entities/custom_tab_type.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_user_setting_value_by_notice_type_use_case.dart';

import '../../../../support/unit_test_bootstrap.dart';

void main() {
  ensureTestBinding();

  group('GetUserSettingValueByNoticeTypeUseCase 유닛 테스트', () {
    setUp(() async {
      await resetMockPrefs();
    });

    test('설정 대상 noticeType이면 저장된 설정 값을 반환한다', () async {
      final prefs = await seedMockPrefs({
        SharedPrefKeys.kMajorKey: 'CSE',
      });
      final manager = SharedPrefsManager(prefs);
      await manager.loadPreferences();
      final useCase =
          GetUserSettingValueByNoticeTypeUseCase(sharedPrefsManager: manager);

      final result = useCase(CustomTabType.major.noticeType);

      expect(result, 'CSE');
    });

    test('설정 대상이 아닌 noticeType이면 null을 반환한다', () async {
      final prefs = await seedMockPrefs({
        SharedPrefKeys.kMajorKey: 'CSE',
      });
      final manager = SharedPrefsManager(prefs);
      await manager.loadPreferences();
      final useCase =
          GetUserSettingValueByNoticeTypeUseCase(sharedPrefsManager: manager);

      final result = useCase(CustomTabType.library.noticeType);

      expect(result, isNull);
    });
  });
}
