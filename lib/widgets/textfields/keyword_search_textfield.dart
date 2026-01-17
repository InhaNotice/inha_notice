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

class KeywordSearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmitted;

  const KeywordSearchTextField(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.onSubmitted});

  @override
  State<KeywordSearchTextField> createState() => _KeywordSearchTextFieldState();
}

class _KeywordSearchTextFieldState extends State<KeywordSearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedSize(
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: TextField(
          focusNode: widget.focusNode,
          cursorColor: Colors.blue,
          controller: widget.controller,
          textInputAction: TextInputAction.search,
          style: TextStyle(
            fontFamily: Fonts.kDefaultFont,
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultThemedTextColor,
          ),
          decoration: InputDecoration(
            hintText: '검색어를 입력하세요',
            hintStyle: TextStyle(
              fontFamily: Fonts.kDefaultFont,
              fontSize: 16,
              color: Theme.of(context).textFieldTextColor,
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        widget.controller.clear();
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
          ),
          onSubmitted: (_) => widget.onSubmitted(),
          onChanged: (value) => setState(() {}),
        ),
      ),
    );
  }
}
