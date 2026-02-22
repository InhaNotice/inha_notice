/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';

/// 플랫폼별 선택 다이얼로그를 표시하는 공통 위젯
///
/// iOS에서는 [CupertinoActionSheet]를, Android에서는 [AlertDialog]를 사용한다.
void showPlatformSelectionDialog<T>({
  required BuildContext context,
  required List<T> options,
  required T currentValue,
  required String Function(T) getDisplayName,
  required void Function(T) onSelected,
}) {
  // iOS 환경
  if (Platform.isIOS) {
    showCupertinoModalPopup(
      context: context,
      builder: (dialogContext) => CupertinoActionSheet(
        actions: options
            .map(
              (option) => CupertinoActionSheetAction(
                onPressed: () {
                  onSelected(option);
                  Navigator.of(dialogContext).pop();
                },
                isDefaultAction: option == currentValue,
                child: Text(
                  getDisplayName(option),
                  style: TextStyle(
                    fontFamily: AppFont.pretendard.family,
                    fontSize: 16,
                    fontWeight: option == currentValue
                        ? FontWeight.w800
                        : FontWeight.normal,
                    color: Theme.of(context).dialogTextColor,
                  ),
                ),
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(
            '취소',
            style: TextStyle(
              fontFamily: AppFont.pretendard.family,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).dialogTextColor,
            ),
          ),
        ),
      ),
    );
  } else {
    // Android 환경
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map((option) => RadioListTile<T>(
                    title: Text(
                      getDisplayName(option),
                      style: TextStyle(
                        fontFamily: AppFont.pretendard.family,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Theme.of(context).defaultThemedTextColor,
                      ),
                    ),
                    value: option,
                    groupValue: currentValue,
                    onChanged: (value) {
                      if (value != null) {
                        onSelected(value);
                        Navigator.of(dialogContext).pop();
                      }
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
