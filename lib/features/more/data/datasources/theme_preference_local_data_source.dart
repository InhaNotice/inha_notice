/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_theme_type.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';

abstract class ThemePreferenceLocalDataSource {
  ThemeMode getThemeMode();
  Future<void> setThemeMode(ThemeMode themeMode);
}

class ThemePreferenceLocalDataSourceImpl
    implements ThemePreferenceLocalDataSource {
  final SharedPrefsManager sharedPrefsManager;

  ThemePreferenceLocalDataSourceImpl({required this.sharedPrefsManager});

  @override
  ThemeMode getThemeMode() {
    final String userThemeSetting =
        sharedPrefsManager.getValue<String>(SharedPrefKeys.kUserThemeSetting) ??
            AppThemeType.system.text;

    if (userThemeSetting == AppThemeType.light.text) {
      return ThemeMode.light;
    }
    if (userThemeSetting == AppThemeType.dark.text) {
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    final String value;
    switch (themeMode) {
      case ThemeMode.light:
        value = AppThemeType.light.text;
      case ThemeMode.dark:
        value = AppThemeType.dark.text;
      case ThemeMode.system:
        value = AppThemeType.system.text;
    }
    await sharedPrefsManager.setValue<String>(
        SharedPrefKeys.kUserThemeSetting, value);
  }
}
