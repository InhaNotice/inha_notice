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

class ThemedSnackBar {
  static void succeedSnackBar(BuildContext context, String message) {
    if (Platform.isIOS) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ $message',
            style: TextStyle(
                fontFamily: AppFont.tossFaceFontMac.family,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).snackBarTextColor),
          ),
          backgroundColor: Theme.of(context).snackBarBackgroundColor,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      // Android
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).snackBarTextColor),
          ),
          backgroundColor: Theme.of(context).snackBarBackgroundColor,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  static void failSnackBar(BuildContext context, String message) {
    if (Platform.isIOS) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '❌ $message',
            style: TextStyle(
                fontFamily: AppFont.tossFaceFontMac.family,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).snackBarTextColor),
          ),
          backgroundColor: Theme.of(context).snackBarBackgroundColor,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      // Android
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).snackBarTextColor),
          ),
          backgroundColor: Theme.of(context).snackBarBackgroundColor,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  static void warnSnackBar(BuildContext context, String message) {
    if (Platform.isIOS) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '⚠️ $message',
            style: TextStyle(
              fontFamily: AppFont.tossFaceFontMac.family,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).snackBarTextColor,
            ),
          ),
          backgroundColor: Theme.of(context).snackBarBackgroundColor,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      // Android
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).snackBarTextColor),
          ),
          backgroundColor: Theme.of(context).snackBarBackgroundColor,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}
