/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-03-03
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_bloc.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_state.dart';
import 'package:inha_notice/features/user_preference/presentation/widgets/language_selection_dialog.dart';

/// **LanguagePreferenceTile**
/// 사용자의 현재 언어 설정을 보여주기 위한 타일입니다.
///
/// ### 주요 기능:
/// - 현재 설정된 언어 확인 가능
/// - 언어 설정 변경 가능 (handleLanguagePreferenceTap)
class LanguagePreferenceTile extends StatelessWidget {
  final String title;
  final IconData icon;

  const LanguagePreferenceTile({
    super.key,
    required this.title,
    required this.icon,
  });

  /// **다이얼로그 표시**
  Future<void> handleLanguagePreferenceTap(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) => const LanguageSelectionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleLanguagePreferenceTap(context),
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
                Icon(icon, size: 20, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppFont.pretendard.family,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Theme.of(context).defaultThemedTextColor,
                  ),
                ),
              ],
            ),
            BlocBuilder<UserPreferenceBloc, UserPreferenceState>(
              builder: (context, state) {
                if (state is UserPreferenceLoaded) {
                  return Text(
                    state.preferences.languagePreference.text,
                    style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).dialogGreyTextColor,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
