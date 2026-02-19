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
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/university_setting/data/datasources/university_setting_local_data_source.dart';

class _FakeSharedPrefsManager extends SharedPrefsManager {
  _FakeSharedPrefsManager() : super(null);

  final Map<String, dynamic> values = {};
  String? lastMajorOldKey;
  String? lastMajorNewKey;
  String? lastMajorKeyType;

  @override
  T? getValue<T>(String key) {
    final value = values[key];
    if (value is T) return value;
    return null;
  }

  @override
  Future<void> setValue<T>(String key, T value) async {
    values[key] = value;
  }

  @override
  Future<void> setMajorPreference(
      String? currentMajorKey, String newMajorKey, String majorKeyType) async {
    lastMajorOldKey = currentMajorKey;
    lastMajorNewKey = newMajorKey;
    lastMajorKeyType = majorKeyType;
  }
}

void main() {
  group('UniversitySettingLocalDataSourceImpl 유닛 테스트', () {
    late _FakeSharedPrefsManager prefs;
    late UniversitySettingLocalDataSourceImpl dataSource;

    setUp(() {
      prefs = _FakeSharedPrefsManager();
      dataSource = UniversitySettingLocalDataSourceImpl(prefsManager: prefs);
    });

    test('getCurrentSetting은 저장된 문자열 값을 반환한다', () {
      prefs.values['major-key'] = 'CSE';

      final result = dataSource.getCurrentSetting('major-key');

      expect(result, 'CSE');
    });

    test('saveSetting은 prefKey/value를 저장한다', () async {
      await dataSource.saveSetting('college-key', 'SWCC');

      expect(prefs.values['college-key'], 'SWCC');
    });

    test('saveMajorSetting은 setMajorPreference를 호출한다', () async {
      await dataSource.saveMajorSetting('MECH', 'CSE', 'major-key');

      expect(prefs.lastMajorOldKey, 'MECH');
      expect(prefs.lastMajorNewKey, 'CSE');
      expect(prefs.lastMajorKeyType, 'major-key');
    });
  });
}
