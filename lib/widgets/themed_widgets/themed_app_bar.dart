/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-23
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';

/// **ThemedAppBar**
/// 이 클래스는 화이트/다크모드가 적용된 AppBar 클래스입니다.
class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double titleSize;
  final bool isCenter;

  const ThemedAppBar({
    super.key,
    required this.title,
    required this.titleSize,
    required this.isCenter,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
