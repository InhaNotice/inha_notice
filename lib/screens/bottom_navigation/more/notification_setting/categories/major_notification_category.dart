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
import 'package:inha_notice/core/theme/theme.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/notification_major_item.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/notification_tile.dart';
import 'package:inha_notice/widgets/texts/bold_title_text.dart';

class MajorNotificationCategory extends StatefulWidget {
  final String title;
  final List<NotificationMajorItem> items;

  const MajorNotificationCategory(
      {super.key, required this.title, required this.items});

  @override
  State<MajorNotificationCategory> createState() =>
      _MajorNotificationCategoryState();
}

class _MajorNotificationCategoryState extends State<MajorNotificationCategory> {
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
            BoldTitleText(text: widget.title, size: 20),
            ...widget.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: NotificationTile(
                  title: item.title,
                  prefKey: item.key,
                  fcmTopic: item.topic,
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
