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
import 'package:inha_notice/l10n/app_localizations.dart';

/// 앱 테마 설정 값
enum AppThemeType {
  system('시스템 설정'),
  light('화이트'),
  dark('다크');

  final String text;

  const AppThemeType(this.text);

  /// 다국어 지원을 위한 display name 반환
  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case AppThemeType.system:
        return l10n.themeSystem;
      case AppThemeType.light:
        return l10n.themeLight;
      case AppThemeType.dark:
        return l10n.themeDark;
    }
  }
}
