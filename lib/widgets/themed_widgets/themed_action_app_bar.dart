/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-26
 */
import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';

/// **ThemedActionAppBar**
/// Action 위젯이 포함된 테마가 설정된 AppBar를 정의합니다.
///
/// ### 주요 기능:
/// - 테마(화이트, 다크 모드)가 설정된 AppBar
/// - Action 위젯 설정 가능
class ThemedActionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final double titleSize;
  final bool isCenter;
  final Widget actionWidget;

  const ThemedActionAppBar({
    super.key,
    required this.title,
    required this.titleSize,
    required this.isCenter,
    required this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: isCenter,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: Font.kDefaultFont,
          fontWeight: FontWeight.bold,
          fontSize: titleSize,
          color: Theme.of(context).textTheme.bodyMedium?.color ??
              Theme.of(context).defaultThemedTextColor,
        ),
      ),
      actions: [actionWidget],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
