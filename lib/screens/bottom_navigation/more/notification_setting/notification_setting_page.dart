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
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/categories/college_notification_category.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/categories/education_notification_category.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/categories/graduate_school_notification_category.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/categories/major_notification_category.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/categories/research_notification_category.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/categories/undergraduate_schedule_notification_category.dart';
import 'package:inha_notice/utils/university_utils/major_utils.dart';
import 'package:inha_notice/widgets/app_bars/themed_app_bar.dart';

import 'notification_major_item.dart';

/// **NotificationSettingPage**
/// 이 클래스는 알림 설정 페이지를 정의하는 클래스입니다.
///
/// ### 주요 기능:
/// - 학사 알림을 설정
/// - 학과 알림을 설정
class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  bool connectedValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThemedAppBar(title: '알림 설정', titleSize: 20, isCenter: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UndergraduateScheduleNotificationCategory(),
            EducationNotificationCategory(),
            ResearchNotificationCategory(),
            CollegeNotificationCategory(),
            GraduateSchoolNotificationCategory(),
            ...MajorUtils.majorGroups.entries.map(
              (college) {
                return MajorNotificationCategory(
                    title: college.key,
                    items: MajorUtils.majorGroups[college.key]!.entries
                        .map((entry) {
                      return NotificationMajorItem(
                        title: entry.key,
                        key: entry.value,
                        topic: entry.value,
                      );
                    }).toList());
              },
            ),
          ],
        ),
      ),
    );
  }
}
