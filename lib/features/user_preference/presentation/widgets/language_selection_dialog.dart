/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-03-03
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_language_type.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_bloc.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_event.dart';

/// **LanguageSelectionDialog**
/// 언어를 선택할 수 있는 다이얼로그입니다.
///
/// ### 주요 기능:
/// - 지원되는 언어 중 선택 (한국어, English)
class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({super.key});

  void _setLanguage(BuildContext context, AppLanguageType language) {
    try {
      context.read<UserPreferenceBloc>().add(
            ChangeLanguagePreferenceEvent(language: language),
          );
      AppSnackBar.success(context, '설정되었어요.');
    } catch (e) {
      AppSnackBar.error(context, '다시 시도해주세요.');
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // iOS 환경
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(
          '언어 설정',
          style: TextStyle(
            fontFamily: AppFont.pretendard.family,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultThemedTextColor,
          ),
        ),
        content: Text(
          '원하는 언어를 선택해주세요.',
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
            onPressed: () => _setLanguage(context, AppLanguageType.korean),
            child: Text(
              AppLanguageType.korean.text,
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).dialogTextColor,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => _setLanguage(context, AppLanguageType.english),
            child: Text(
              AppLanguageType.english.text,
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
          '언어 설정',
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
          '원하는 언어를 선택해주세요.',
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
            onPressed: () => _setLanguage(context, AppLanguageType.korean),
            child: Text(
              AppLanguageType.korean.text,
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
            onPressed: () => _setLanguage(context, AppLanguageType.english),
            child: Text(
              AppLanguageType.english.text,
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
