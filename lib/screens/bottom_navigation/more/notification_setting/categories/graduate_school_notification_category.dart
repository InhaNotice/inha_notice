/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-26
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/constants/domain_keys/graduate_school_keys.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/notification_tile.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/widgets/texts/bold_title_text.dart';

class GraduateSchoolNotificationCategory extends StatefulWidget {
  const GraduateSchoolNotificationCategory({super.key});

  @override
  State<GraduateSchoolNotificationCategory> createState() =>
      _GraduateSchoolNotificationCategoryState();
}

class _GraduateSchoolNotificationCategoryState
    extends State<GraduateSchoolNotificationCategory> {
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
            BoldTitleText(text: '대학원', size: 20),
            ...GraduateSchoolKeys.graduateSchoolGroups.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: NotificationTile(
                  title: entry.key,
                  prefKey: entry.value,
                  fcmTopic: entry.value,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
