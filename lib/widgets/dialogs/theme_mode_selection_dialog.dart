/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-18
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/config/app_theme_type.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/injection_container.dart' as di;
import 'package:inha_notice/main.dart';

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
      await di
          .sl<SharedPrefsManager>()
          .setValue<String>(SharedPrefKeys.kUserThemeSetting, selectedValue);

      // 글로벌 themeModeNotifier 업데이트
      if (selectedValue == AppThemeType.light.text) {
        themeModeNotifier.value = ThemeMode.light;
      } else if (selectedValue == AppThemeType.dark.text) {
        themeModeNotifier.value = ThemeMode.dark;
      } else {
        themeModeNotifier.value = ThemeMode.system;
      }

      if (mounted) {
        AppSnackBar.success(context, '설정되었어요.');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, '다시 시도해주세요.');
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
            fontFamily: AppFont.pretendard.family,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultThemedTextColor,
          ),
        ),
        content: Text(
          '원하는 모드를 선택해주세요.',
          style: TextStyle(
            fontFamily: AppFont.pretendard.family,
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultThemedTextColor,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => _setThemeMode(AppThemeType.system.text),
            child: Text(
              '시스템 설정',
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).dialogTextColor,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => _setThemeMode(AppThemeType.light.text),
            child: Text(
              AppThemeType.light.text,
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).dialogTextColor,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => _setThemeMode(AppThemeType.dark.text),
            child: Text(
              AppThemeType.dark.text,
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
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
            fontFamily: AppFont.pretendard.family,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultThemedTextColor,
          ),
        ),
        content: Text(
          '원하는 모드를 선택해주세요.',
          style: TextStyle(
            fontFamily: AppFont.pretendard.family,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultThemedTextColor,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => _setThemeMode(AppThemeType.system.text),
            child: Text(
              AppThemeType.system.text,
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _setThemeMode(AppThemeType.light.text),
            child: Text(
              AppThemeType.light.text,
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _setThemeMode(AppThemeType.dark.text),
            child: Text(
              AppThemeType.dark.text,
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
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
