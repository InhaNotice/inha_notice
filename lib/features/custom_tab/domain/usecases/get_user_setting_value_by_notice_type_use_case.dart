/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/custom_tab/domain/entities/custom_tab_type.dart';

class GetUserSettingValueByNoticeTypeUseCase {
  final SharedPrefsManager sharedPrefsManager;

  GetUserSettingValueByNoticeTypeUseCase({required this.sharedPrefsManager});

  String? call(String noticeType) {
    final CustomTabType? tab = CustomTabType.fromNoticeType(noticeType);
    if (tab == null) return null;

    final String? prefKey = tab.userSettingPrefKey;
    if (prefKey == null) return null;

    return sharedPrefsManager.getValue<String>(prefKey);
  }
}
