/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-25
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/font/fonts.dart';
import 'package:inha_notice/core/theme/theme.dart';

/// **MoreTitleTile**
/// 이 클래스는 더보기 페이지의 제목 타일을 정의하는 클래스입니다.
class MoreTitleTile extends StatefulWidget {
  final String text;
  final double fontSize;

  const MoreTitleTile({super.key, required this.text, required this.fontSize});

  @override
  State<MoreTitleTile> createState() => _MoreTitleTileState();
}

class _MoreTitleTileState extends State<MoreTitleTile> {
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
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).fixedGreyText,
            ),
          ),
        ],
      ),
    );
  }
}
