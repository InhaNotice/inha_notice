/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/config/app_theme.dart';

Future<void> pumpInhaApp(
  WidgetTester tester, {
  required Widget child,
  ThemeMode themeMode = ThemeMode.light,
  bool wrapWithScaffold = true,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: wrapWithScaffold ? Scaffold(body: child) : child,
    ),
  );

  await tester.pump();
}
