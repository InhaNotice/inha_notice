/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';

class SettingHeader extends StatelessWidget {
  final String settingTypeName;
  final String? currentSettingName;

  const SettingHeader({
    super.key,
    required this.settingTypeName,
    required this.currentSettingName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        currentSettingName != null
            ? '현재 $settingTypeName: $currentSettingName'
            : '$settingTypeName를 설정해주세요!',
        style: TextStyle(
          fontFamily: AppFont.pretendard.family,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyMedium?.color ??
              Theme.of(context).defaultThemedTextColor,
        ),
      ),
    );
  }
}
