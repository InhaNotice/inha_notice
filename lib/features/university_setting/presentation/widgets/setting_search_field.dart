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

class SettingSearchField extends StatelessWidget {
  final String searchLabel;
  final ValueChanged<String> onChanged;

  const SettingSearchField({
    super.key,
    required this.searchLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: searchLabel,
        labelStyle: TextStyle(
          fontFamily: AppFont.pretendard.family,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Theme.of(context).hintColor,
        ),
        filled: false,
        prefixIcon:
            Icon(Icons.search, color: Theme.of(context).iconTheme.color),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Theme.of(context).boxBorderColor,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.5),
        ),
      ),
    );
  }
}
