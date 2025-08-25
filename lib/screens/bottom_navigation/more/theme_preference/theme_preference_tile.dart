/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-25
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inha_notice/core/font/fonts.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/theme/theme.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/widgets/dialogs/theme_mode_selection_dialog.dart';

/// **ThemePreferenceTile**
/// 사용자의 현재 테마 설정을 보여주기 위한 타일입니다.
///
/// ### 주요 기능:
/// - 현재 설정된 테마 설정 확인 가능
/// - 테마 설정 변경 가능(handleThemePreferenceTap)
class ThemePreferenceTile extends StatefulWidget {
  final String title;
  final IconData icon;

  const ThemePreferenceTile({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  State<ThemePreferenceTile> createState() => _ThemePreferenceTileState();
}

class _ThemePreferenceTileState extends State<ThemePreferenceTile> {
  String description =
      SharedPrefsManager().getPreference(SharedPrefKeys.kUserThemeSetting);

  /// **다이얼로그 push -> pop 후, 변경사항 반영**
  Future<void> handleThemePreferenceTap() async {
    await showCupertinoDialog(
      context: context,
      builder: (context) => const ThemeModeSelectionDialog(),
    );
    setState(() {
      description =
          SharedPrefsManager().getPreference(SharedPrefKeys.kUserThemeSetting);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await handleThemePreferenceTap();
      },
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(widget.icon,
                    size: 20, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: Fonts.kDefaultFont,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Theme.of(context).defaultThemedTextColor,
                  ),
                ),
              ],
            ),
            Text(
              description,
              style: TextStyle(
                  fontFamily: Fonts.kDefaultFont,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).dialogGreyTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
