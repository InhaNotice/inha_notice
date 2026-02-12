/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';

abstract class NotificationSettingLocalDataSource {
  bool getSubscriptionStatus(String prefKey);

  Future<void> saveSubscriptionStatus(
      String prefKey, bool value, bool isSynchronizedWithMajor);
}

class NotificationSettingLocalDataSourceImpl
    implements NotificationSettingLocalDataSource {
  final SharedPrefsManager prefsManager;

  NotificationSettingLocalDataSourceImpl({required this.prefsManager});

  @override
  bool getSubscriptionStatus(String prefKey) {
    final majorKey = prefsManager.getValue<String>(SharedPrefKeys.kMajorKey);

    // 현재 설정된 나의 학과인 경우, 나의 학과의 설정된 불 값으로 반영
    if (majorKey != null && prefKey == majorKey) {
      return prefsManager.getValue<bool>(SharedPrefKeys.kMajorNotification) ??
          false;
    }

    return prefsManager.getValue<bool>(prefKey) ?? false;
  }

  @override
  Future<void> saveSubscriptionStatus(
      String prefKey, bool value, bool isSynchronizedWithMajor) async {
    if (isSynchronizedWithMajor) {
      await prefsManager.setValue<bool>(
          SharedPrefKeys.kMajorNotification, value);
    }
    await prefsManager.setValue<bool>(prefKey, value);
  }
}
