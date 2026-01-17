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
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/notification_tile.dart';
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
              title: '학사',
              description: '인하대학교 전체 공지사항',
              prefKey: SharedPrefKeys.kAcademicNotification,
              fcmTopic: SharedPrefKeys.kAllNotices,
            ),
            const SizedBox(height: 8),
            NotificationTile(
              title: '장학',
              description: '인하대학교 장학 공지사항',
              prefKey: SharedPrefKeys.kScholarship,
              fcmTopic: SharedPrefKeys.kScholarship,
            ),
            const SizedBox(height: 8),
            NotificationTile(
              title: '모집/채용',
              description: '인하대학교 모집 및 채용 공지사항',
              prefKey: SharedPrefKeys.kRecruitment,
              fcmTopic: SharedPrefKeys.kRecruitment,
            ),
            const SizedBox(height: 8),
            NotificationTile(
              title: '국제처',
              description: '교환학생, 해외연수 및 글로벌 프로그램 안내',
              prefKey: SharedPrefKeys.INTERNATIONAL,
              fcmTopic: SharedPrefKeys.INTERNATIONAL,
            ),
            const SizedBox(height: 8),
            NotificationTile(
              title: '정석학술정보관',
              description: '인하대학교 정석학술정보관 공지사항',
              prefKey: SharedPrefKeys.kLibrary,
              fcmTopic: SharedPrefKeys.kLibrary,
            ),
          ],
        ),
      ),
    );
  }
}
