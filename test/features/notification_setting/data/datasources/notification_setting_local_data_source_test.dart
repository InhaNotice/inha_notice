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
import 'package:inha_notice/features/notification_setting/data/datasources/notification_setting_local_data_source.dart';

class _FakeSharedPrefsManager extends SharedPrefsManager {
  _FakeSharedPrefsManager() : super(null);

  final Map<String, dynamic> values = {};

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
}

void main() {
  group('NotificationSettingLocalDataSourceImpl 유닛 테스트', () {
    late _FakeSharedPrefsManager prefs;
    late NotificationSettingLocalDataSourceImpl dataSource;

    setUp(() {
      prefs = _FakeSharedPrefsManager();
      dataSource = NotificationSettingLocalDataSourceImpl(prefsManager: prefs);
    });

    test('현재 학과 키와 동일하면 major_notification 값을 반환한다', () {
      prefs.values[SharedPrefKeys.kMajorKey] = 'CSE';
      prefs.values[SharedPrefKeys.kMajorNotification] = true;
      prefs.values['CSE'] = false;

      final result = dataSource.getSubscriptionStatus('CSE');

      expect(result, isTrue);
    });

    test('현재 학과 키와 다르면 prefKey 값을 반환한다', () {
      prefs.values[SharedPrefKeys.kMajorKey] = 'CSE';
      prefs.values['SWUNIV'] = true;

      final result = dataSource.getSubscriptionStatus('SWUNIV');

      expect(result, isTrue);
    });

    test('동기화 true면 major_notification과 prefKey를 모두 저장한다', () async {
      await dataSource.saveSubscriptionStatus('CSE', true, true);

      expect(prefs.values[SharedPrefKeys.kMajorNotification], isTrue);
      expect(prefs.values['CSE'], isTrue);
    });

    test('동기화 false면 prefKey만 저장한다', () async {
      await dataSource.saveSubscriptionStatus('SWUNIV', false, false);

      expect(
          prefs.values.containsKey(SharedPrefKeys.kMajorNotification), isFalse);
      expect(prefs.values['SWUNIV'], isFalse);
    });
  });
}
