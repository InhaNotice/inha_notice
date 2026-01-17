/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

/// 앱 테마 설정 값
enum AppThemeType {
  system('시스템 설정'),
  light('화이트'),
  dark('다크');

  final String text;

  const AppThemeType(this.text);
}
