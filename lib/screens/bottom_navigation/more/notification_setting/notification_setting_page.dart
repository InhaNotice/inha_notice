/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-19
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/features/notice/domain/entities/major_type.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/categories/college_notification_category.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/categories/education_notification_category.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/categories/graduate_school_notification_category.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/categories/major_notification_category.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/categories/research_notification_category.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/categories/undergraduate_schedule_notification_category.dart';

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
      appBar: const CommonAppBarWidget(
          title: '알림 설정', titleSize: 20, isCenter: true),
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
            ...MajorType.majorGroups.entries.map(
              (college) {
                return MajorNotificationCategory(
                    title: college.key,
                    items: college.value.entries.map((major) {
                      return NotificationMajorItem(
                        title: major.key,
                        key: major.value,
                        topic: major.value,
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
