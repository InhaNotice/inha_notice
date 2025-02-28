/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-25
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/constants/shared_pref_keys/shared_pref_keys.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/notification_tile.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/widgets/texts/bold_title_text.dart';

class EducationNotificationCategory extends StatefulWidget {
  const EducationNotificationCategory({super.key});

  @override
  State<EducationNotificationCategory> createState() =>
      _EducationNotificationCategoryState();
}

class _EducationNotificationCategoryState
    extends State<EducationNotificationCategory> {
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
            BoldTitleText(text: '교육 및 행정 지원', size: 20),
            NotificationTile(
              title: '전체공지',
              description: '인하대학교 공식 사이트의 공지사항',
              prefKey: SharedPrefKeys.kAcademicNotification,
              fcmTopic: SharedPrefKeys.kAllNotices,
            ),
            const SizedBox(height: 8),
            NotificationTile(
              title: '국제처',
              description: '(교환학생, 해외지역연구, 서포터즈, 취업) 정보',
              prefKey: SharedPrefKeys.INTERNATIONAL,
              fcmTopic: SharedPrefKeys.INTERNATIONAL,
            ),
          ],
        ),
      ),
    );
  }
}
