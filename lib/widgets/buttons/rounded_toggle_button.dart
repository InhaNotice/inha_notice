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

/// **RoundedToggleButton**
/// 이 클래스는 타원형태의 토글 버튼을 제공하는 클래스입니다.
class RoundedToggleButton extends StatelessWidget {
  final String text;
  final String option;
  final bool isSelected;
  final Function(String) onTap;

  const RoundedToggleButton({
    super.key,
    required this.text,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(option),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).selectedToggleBorder
                : Theme.of(context).unSelectedToggleBorder,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: Fonts.kDefaultFont,
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Theme.of(context).selectedToggleText
                : Theme.of(context).unSelectedToggleText,
          ),
        ),
      ),
    );
  }
}
