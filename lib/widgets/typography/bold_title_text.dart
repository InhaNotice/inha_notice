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

/// **BoldTitleTile**
class BoldTitleText extends StatefulWidget {
  final String text;
  final double size;

  const BoldTitleText({super.key, required this.text, required this.size});

  @override
  State<BoldTitleText> createState() => _BoldTitleTextState();
}

class _BoldTitleTextState extends State<BoldTitleText> {
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
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyMedium?.color ??
                  Theme.of(context).defaultThemedTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
