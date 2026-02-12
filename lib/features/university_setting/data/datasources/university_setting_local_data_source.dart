/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:inha_notice/core/utils/shared_prefs_manager.dart';

abstract class UniversitySettingLocalDataSource {
  String? getCurrentSetting(String prefKey);
  Future<void> saveSetting(String prefKey, String value);
  Future<void> saveMajorSetting(
      String? oldKey, String newKey, String majorKeyType);
}

class UniversitySettingLocalDataSourceImpl
    implements UniversitySettingLocalDataSource {
  final SharedPrefsManager prefsManager;

  UniversitySettingLocalDataSourceImpl({required this.prefsManager});

  @override
  String? getCurrentSetting(String prefKey) {
    return prefsManager.getValue<String>(prefKey);
  }

  @override
  Future<void> saveSetting(String prefKey, String value) async {
    await prefsManager.setValue<String>(prefKey, value);
  }

  @override
  Future<void> saveMajorSetting(
      String? oldKey, String newKey, String majorKeyType) async {
    await prefsManager.setMajorPreference(oldKey, newKey, majorKeyType);
  }
}
