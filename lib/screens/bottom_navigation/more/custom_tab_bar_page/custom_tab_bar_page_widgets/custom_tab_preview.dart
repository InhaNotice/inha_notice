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

/// **CustomTabPreview**
/// 현재 설정된 나만의 탭 구성 미리보기를 제공합니다.
///
/// ### 주요 기능:
/// - 미리보기 제공
class CustomTabPreview extends StatelessWidget {
  final List<String> selectedTabs;

  const CustomTabPreview({super.key, required this.selectedTabs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).tabPreviewBoxBorder, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: selectedTabs.map((tab) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Chip(
                backgroundColor: Theme.of(context).chipBackground,
                label: Text(
                  tab,
                  style: TextStyle(
                    fontFamily: Fonts.kDefaultFont,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).chipText,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(
                      color: Theme.of(context).dividerColor, width: 2.5),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
