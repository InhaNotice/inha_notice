/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-03-01
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inha_notice/screens/bottom_navigation/more/custom_license/custom_license_text_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/more_page_titles/more_navigation_tile.dart';
import 'package:inha_notice/screens/bottom_navigation/more/more_page_titles/more_title_tile.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_app_bar.dart';

/// **CustomLicensePage**
/// 라이선스 페이지를 정의합니다.
///
/// ### 주요 기능:
/// - licenses.json을 불러와 라이선스 기본 페이지를 구현
class CustomLicensePage extends StatefulWidget {
  const CustomLicensePage({super.key});

  @override
  State<CustomLicensePage> createState() => _CustomLicensePageState();
}

class _CustomLicensePageState extends State<CustomLicensePage> {
  Map<String, dynamic> _licensesData = {};

  @override
  void initState() {
    super.initState();
    _loadLicensesData();
  }

  Future<void> _loadLicensesData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/licenses/licenses.json');
      setState(() {
        _licensesData = json.decode(jsonString);
      });
    } catch (e) {
      setState(() {
        _licensesData = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const ThemedAppBar(title: '사용된 라이선스', titleSize: 20, isCenter: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _licensesData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: _licensesData.keys.length,
              itemBuilder: (context, index) {
                final String category = _licensesData.keys.elementAt(index);
                final Map licenses = _licensesData[category];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MoreTitleTile(text: category, fontSize: 20),
                    ...licenses.entries.map<Widget>((entry) {
                      final String packageName = entry.key;
                      final String licenseText = entry.value;
                      return MoreNavigationTile(
                        title: packageName,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomLicenseTextPage(
                                  appBarTitle: packageName,
                                  description: licenseText),
                            ),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
    );
  }
}
