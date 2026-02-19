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
import 'package:inha_notice/features/custom_tab/domain/usecases/get_major_display_name_use_case.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_user_setting_value_by_notice_type_use_case.dart';
import 'package:inha_notice/features/notice/data/datasources/home_local_data_source.dart';

class _FakeSharedPrefsManager extends SharedPrefsManager {
  _FakeSharedPrefsManager() : super(null);

  final Map<String, dynamic> values = {};

  @override
  T? getValue<T>(String key) {
    final value = values[key];
    if (value is T) return value;
    return null;
  }
}

void main() {
  group('HomeLocalDataSourceImpl 유닛 테스트', () {
    late _FakeSharedPrefsManager prefs;
    late HomeLocalDataSourceImpl dataSource;

    setUp(() {
      prefs = _FakeSharedPrefsManager();
      dataSource = HomeLocalDataSourceImpl(
        prefs,
        getUserSettingValueByNoticeTypeUseCase:
            GetUserSettingValueByNoticeTypeUseCase(sharedPrefsManager: prefs),
        getMajorDisplayNameUseCase: GetMajorDisplayNameUseCase(),
      );
    });

    test('저장된 탭이 없으면 기본 탭 목록을 반환한다', () async {
      final tabs = await dataSource.fetchHomeTabs();

      expect(tabs, isNotEmpty);
      expect(tabs.first.noticeType, 'WHOLE');
    });

    test('학과 탭은 설정된 학과 키를 표시 이름으로 변환한다', () async {
      prefs.values[SharedPrefKeys.kCustomTabList] = ['학과'];
      prefs.values[SharedPrefKeys.kMajorKey] = 'CSE';

      final tabs = await dataSource.fetchHomeTabs();

      expect(tabs.length, 1);
      expect(tabs.first.noticeType, 'MAJOR');
      expect(tabs.first.label, '컴퓨터공학과');
    });
  });
}
