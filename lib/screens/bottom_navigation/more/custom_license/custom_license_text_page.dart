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
import 'package:inha_notice/widgets/themed_widgets/themed_app_bar.dart';

/// **CustomLicenseTextPage**
/// 라이선스 본문을 출력하는 페이지입니다.
class CustomLicenseTextPage extends StatefulWidget {
  final String appBarTitle;

  final String description;

  const CustomLicenseTextPage(
      {super.key, required this.appBarTitle, required this.description});

  @override
  State<CustomLicenseTextPage> createState() => _CustomLicenseTextPageState();
}

class _CustomLicenseTextPageState extends State<CustomLicenseTextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
          title: widget.appBarTitle, titleSize: 20, isCenter: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  softWrap: true,
                  widget.description,
                  style: TextStyle(
                    fontFamily: Fonts.kDefaultFont,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Theme.of(context).defaultThemedTextColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
