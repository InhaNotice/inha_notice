/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';

class AppSnackBar {
  AppSnackBar._();

  static void success(BuildContext context, String message) {
    _show(context, message, emoji: '✅');
  }

  static void error(BuildContext context, String message) {
    _show(context, message, emoji: '❌');
  }

  static void warn(BuildContext context, String message) {
    _show(context, message, emoji: '⚠️');
  }

  static void _show(
    BuildContext context,
    String message, {
    required String emoji,
  }) {
    final String textContent = Platform.isIOS ? '$emoji $message' : message;

    final String fontFamily = Platform.isIOS
        ? AppFont.tossFaceFontMac.family
        : AppFont.pretendard.family;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          textContent,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).snackBarTextColor,
          ),
        ),
        backgroundColor: Theme.of(context).snackBarBackgroundColor,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
