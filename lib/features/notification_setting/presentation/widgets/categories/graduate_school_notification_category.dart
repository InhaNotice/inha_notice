/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/widgets/bold_title_widget.dart';
import 'package:inha_notice/features/notice/domain/entities/graduate_school_type.dart';
import 'package:inha_notice/features/notification_setting/presentation/widgets/notification_tile.dart';

class GraduateSchoolNotificationCategory extends StatelessWidget {
  const GraduateSchoolNotificationCategory({super.key});

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
            BoldTitleWidget(text: '대학원', size: 20),
            ...GraduateSchoolType.graduateSchoolMappingOnName.entries
                .map((entry) {
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
