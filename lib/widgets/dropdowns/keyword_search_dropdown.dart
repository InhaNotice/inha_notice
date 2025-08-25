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
import 'package:inha_notice/core/constants/keyword_search_option_constants.dart';
import 'package:inha_notice/core/font/fonts.dart';
import 'package:inha_notice/themes/theme.dart';

class KeywordSearchDropdown extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const KeywordSearchDropdown(
      {super.key, required this.value, required this.onChanged});

  @override
  State<KeywordSearchDropdown> createState() => _KeywordSearchDropdownState();
}

class _KeywordSearchDropdownState extends State<KeywordSearchDropdown> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const StadiumBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 2,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.value,
              isDense: true,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              icon: const Icon(
                Icons.expand_more_sharp,
                size: 18,
              ),
              style: TextStyle(
                fontFamily: Fonts.kDefaultFont,
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultThemedTextColor,
              ),
              items: [
                DropdownMenuItem<String>(
                  value: KeywordSearchOptionConstants.kTitle,
                  child: Text(
                    '제목',
                    style: TextStyle(
                      fontFamily: Fonts.kDefaultFont,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color ??
                          Theme.of(context).defaultThemedTextColor,
                    ),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: KeywordSearchOptionConstants.kWriter,
                  child: Text(
                    '작성자',
                    style: TextStyle(
                      fontFamily: Fonts.kDefaultFont,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color ??
                          Theme.of(context).defaultThemedTextColor,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                widget.onChanged(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}
