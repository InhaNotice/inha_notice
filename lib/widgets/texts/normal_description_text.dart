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
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/font/fonts.dart';

/// **NormalDescriptionText**
/// 이 클래스는 더보기 페이지의 제목 타일을 정의하는 클래스입니다.
class NormalDescriptionText extends StatefulWidget {
  final String text;
  final double size;

  const NormalDescriptionText(
      {super.key, required this.text, required this.size});

  @override
  State<NormalDescriptionText> createState() => _NormalDescriptionTextState();
}

class _NormalDescriptionTextState extends State<NormalDescriptionText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.text,
            style: TextStyle(
              fontFamily: Fonts.kDefaultFont,
              fontSize: widget.size,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).textTheme.bodyMedium?.color ??
                  Theme.of(context).defaultThemedTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
