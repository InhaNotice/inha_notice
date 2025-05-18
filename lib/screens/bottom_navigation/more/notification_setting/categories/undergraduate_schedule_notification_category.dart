import 'package:flutter/material.dart';
import 'package:inha_notice/constants/shared_pref_keys/shared_pref_keys.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/notification_tile.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/widgets/texts/bold_title_text.dart';

class UndergraduateScheduleNotificationCategory extends StatefulWidget {
  const UndergraduateScheduleNotificationCategory({super.key});

  @override
  State<UndergraduateScheduleNotificationCategory> createState() =>
      _UndergraduateScheduleNotificationCategoryState();
}

class _UndergraduateScheduleNotificationCategoryState
    extends State<UndergraduateScheduleNotificationCategory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.transparent,
            border: Border.all(
              color: Theme.of(context).boxBorderColor,
              width: 0.7,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoldTitleText(text: '학사일정', size: 20),
              NotificationTile(
                title: '하루 전 알림',
                description: '18시에 다음 날 일정을 미리 알려드려요.',
                prefKey: SharedPrefKeys.kUndergraduateScheduleD1Notification,
                fcmTopic: SharedPrefKeys.kUndergraduateScheduleD1Notification,
              ),
              NotificationTile(
                title: '당일 알림',
                description: '오늘 일정을 8시에 알려드려요.',
                prefKey: SharedPrefKeys.kUndergraduateScheduleDDNotification,
                fcmTopic: SharedPrefKeys.kUndergraduateScheduleDDNotification,
              ),
            ],
          )),
    );
  }
}
