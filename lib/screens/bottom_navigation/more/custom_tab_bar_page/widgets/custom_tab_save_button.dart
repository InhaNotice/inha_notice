/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-27
 */
import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_snack_bar.dart';

/// **CustomTabSaveButton**
/// 커스텀 된 탭 저장 버튼을 제공합니다.
///
/// ### 주요 기능:
/// - 변경 사항이 없다면, 회색 배경의 체크 표시 아이콘 표시
/// - 변경 사항이 있다면, 초록색 배경의 체크 표시 아이콘 표시
class CustomTabSaveButton extends StatelessWidget {
  final bool hasChanges;
  final Future<void> Function() onSave;

  const CustomTabSaveButton({
    super.key,
    required this.hasChanges,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: hasChanges
          ? () async => await onSave()
          : () {
              ThemedSnackBar.warnSnackBar(context, '변경사항이 없어요.');
            },
      child: Text(
        hasChanges ? "✅" : "☑️",
        style: TextStyle(
          fontFamily: Font.kTossFaceFontMac,
          fontSize: 25,
        ),
      ),
    );
  }
}
