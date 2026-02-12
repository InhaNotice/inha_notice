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
import 'package:inha_notice/features/custom_tab/domain/entities/custom_tab_type.dart';

abstract class CustomTabLocalDataSource {
  List<String> getSelectedTabs();
  Future<void> saveTabs(List<String> tabs);
}

class CustomTabLocalDataSourceImpl implements CustomTabLocalDataSource {
  final SharedPrefsManager prefsManager;

  CustomTabLocalDataSourceImpl({required this.prefsManager});

  @override
  List<String> getSelectedTabs() {
    final List<String>? savedTabs =
        prefsManager.getValue<List<String>>(SharedPrefKeys.kCustomTabList);
    if (savedTabs == null || savedTabs.isEmpty) {
      return List.from(CustomTabType.kDefaultTabs);
    }
    return List.from(savedTabs);
  }

  @override
  Future<void> saveTabs(List<String> tabs) async {
    await prefsManager.setValue<List<String>>(
        SharedPrefKeys.kCustomTabList, tabs);
  }
}
