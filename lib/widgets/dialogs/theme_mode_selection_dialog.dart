/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-23
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inha_notice/core/constants/app_theme_constants.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/main.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_snack_bar.dart';

/// **ThemeModeSelectionDialog**
/// 테마 모드를 선택할 수 있는 다이얼로그입니다.
///
/// ### 주요 기능:
/// - 3가지 옵션 제공(시스템 설정, 화이트 모드, 다크 모드)
class ThemeModeSelectionDialog extends StatefulWidget {
  const ThemeModeSelectionDialog({
    super.key,
  });

  @override
  State<ThemeModeSelectionDialog> createState() =>
      _ThemeModeSelectionDialogState();
}

class _ThemeModeSelectionDialogState extends State<ThemeModeSelectionDialog> {
  Future<void> _setThemeMode(String selectedValue) async {
    try {
      await SharedPrefsManager()
          .setPreference(SharedPrefKeys.kUserThemeSetting, selectedValue);

      // 글로벌 themeModeNotifier 업데이트
      switch (selectedValue) {
        case AppThemeConstants.kLight:
          themeModeNotifier.value = ThemeMode.light;
          break;
        case AppThemeConstants.kDark:
          themeModeNotifier.value = ThemeMode.dark;
          break;
        default:
          themeModeNotifier.value = ThemeMode.system;
      }

      if (mounted) {
        ThemedSnackBar.succeedSnackBar(context, '설정되었어요.');
      }
    } catch (e) {
      if (mounted) {
        ThemedSnackBar.failSnackBar(context, '다시 시도해주세요.');
      }
    } finally {
      // 현재 다이얼로그를 pop
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // iOS 환경
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(
          '테마 설정',
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultThemedTextColor,
          ),
        ),
        content: Text(
          '원하는 모드를 선택해주세요.',
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultThemedTextColor,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => _setThemeMode(AppThemeConstants.kSystem),
            child: Text(
              '시스템 설정',
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).dialogTextColor,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => _setThemeMode(AppThemeConstants.kLight),
            child: Text(
              AppThemeConstants.kLight,
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).dialogTextColor,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => _setThemeMode(AppThemeConstants.kDark),
            child: Text(
              AppThemeConstants.kDark,
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).dialogTextColor,
              ),
            ),
          ),
        ],
      );
    } else {
      // Android 환경
      return AlertDialog(
        alignment: Alignment.center,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          '테마 설정',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultThemedTextColor,
          ),
        ),
        content: Text(
          '원하는 모드를 선택해주세요.',
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultThemedTextColor,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => _setThemeMode(AppThemeConstants.kSystem),
            child: Text(
              AppThemeConstants.kSystem,
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _setThemeMode(AppThemeConstants.kLight),
            child: Text(
              AppThemeConstants.kLight,
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _setThemeMode(AppThemeConstants.kDark),
            child: Text(
              AppThemeConstants.kDark,
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
          ),
        ],
      );
    }
  }
}
