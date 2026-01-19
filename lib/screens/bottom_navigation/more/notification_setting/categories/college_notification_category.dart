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
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/widgets/bold_title_widget.dart';
import 'package:inha_notice/features/notice/domain/entities/college_type.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/notification_tile.dart';

/// **NotificationMajorCategory**
/// 모든 학과에 대한 알림 카테고리를 정의한다.
class CollegeNotificationCategory extends StatefulWidget {
  const CollegeNotificationCategory({super.key});

  @override
  State<CollegeNotificationCategory> createState() =>
      _CollegeNotificationCategoryState();
}

class _CollegeNotificationCategoryState
    extends State<CollegeNotificationCategory> {
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
            BoldTitleWidget(text: '단과대', size: 20),
            ...CollegeType.values.map((college) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: NotificationTile(
                  title: college.name,
                  prefKey: college.key,
                  fcmTopic: college.key,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
