/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-26
 */
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inha_notice/constants/shared_pref_keys/shared_pref_keys.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/main.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_snack_bar.dart';

/// **앱 테마 설정 값**
enum AppThemeMode {
  kSystem('시스템 설정'),
  kLight('화이트'),
  kDark('다크');

  const AppThemeMode(this.value);

  final String value;
}

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
  Future<void> _setThemeMode(AppThemeMode key) async {
    final String selectedValue = key.value;

    try {
      await SharedPrefsManager()
          .setPreference(SharedPrefKeys.kUserThemeSetting, selectedValue);

      // 글로벌 themeModeNotifier 업데이트
      switch (selectedValue) {
        case '화이트':
          themeModeNotifier.value = ThemeMode.light;
          break;
        case '다크':
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
                Theme.of(context).defaultColor,
          ),
        ),
        content: Text(
          '원하는 모드를 선택해주세요.',
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultColor,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => _setThemeMode(AppThemeMode.kSystem),
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
            onPressed: () => _setThemeMode(AppThemeMode.kLight),
            child: Text(
              '화이트 모드',
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).dialogTextColor,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => _setThemeMode(AppThemeMode.kDark),
            child: Text(
              '다크 모드',
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
        title: const Text('테마 설정'),
        content: const Text('원하는 모드를 선택해주세요.'),
        actions: [
          TextButton(
            onPressed: () => _setThemeMode(AppThemeMode.kSystem),
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
          TextButton(
            onPressed: () => _setThemeMode(AppThemeMode.kLight),
            child: Text(
              '화이트 모드',
              style: TextStyle(
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).dialogTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _setThemeMode(AppThemeMode.kDark),
            child: Text(
              '다크 모드',
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
    }
  }
}
