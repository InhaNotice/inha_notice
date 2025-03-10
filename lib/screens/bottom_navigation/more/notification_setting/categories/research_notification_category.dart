/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-03-10
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/constants/shared_pref_keys/shared_pref_keys.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/notification_tile.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/widgets/texts/bold_title_text.dart';

class ResearchNotificationCategory extends StatefulWidget {
  const ResearchNotificationCategory({super.key});

  @override
  State<ResearchNotificationCategory> createState() =>
      _ResearchNotificationCategoryState();
}

class _ResearchNotificationCategoryState
    extends State<ResearchNotificationCategory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Theme.of(context).boxBorderColor,
            width: 0.7,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoldTitleText(text: '연구 및 학술 지원', size: 20),
            NotificationTile(
              title: 'SW중심대학사업단',
              description: '해커톤, 부트캠프, 기업 특강 등 최신 SW·AI 프로그램 안내',
              prefKey: SharedPrefKeys.SWUNIV,
              fcmTopic: SharedPrefKeys.SWUNIV,
            )
          ],
        ),
      ),
    );
  }
}
