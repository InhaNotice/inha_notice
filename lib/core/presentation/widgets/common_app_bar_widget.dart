/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';

/// **ThemedActionAppBar**
/// Action 위젯이 포함된 테마가 설정된 AppBar를 정의합니다.
///
/// ### 주요 기능:
/// - 테마(화이트, 다크 모드)가 설정된 AppBar
/// - Action 위젯 설정 가능
class CommonAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final double titleSize;
  final bool isCenter;
  final List<Widget>? actions;

  const CommonAppBarWidget({
    super.key,
    required this.title,
    required this.titleSize,
    required this.isCenter,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: isCenter,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: AppFont.pretendard.family,
          fontWeight: FontWeight.bold,
          fontSize: titleSize,
          color: Theme.of(context).textTheme.bodyMedium?.color ??
              Theme.of(context).defaultThemedTextColor,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
