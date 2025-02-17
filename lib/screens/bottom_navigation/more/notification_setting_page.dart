/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-12
 */
import 'package:flutter/material.dart';
import 'package:inha_notice/screens/bottom_navigation/more/titles/notification_tile.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_app_bar.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThemedAppBar(title: '알림 설정', titleSize: 20, isCenter: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
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
                NotificationTile(
                  title: '학사',
                  description: '인하대학교 공식 사이트의 알림을 받을 수 있습니다.',
                  topic: 'all-notices',
                  getPreference: SharedPrefsManager().getAcademicNotificationOn,
                  setPreference: SharedPrefsManager().setAcademicNotificationOn,
                ),
                const SizedBox(height: 8),
                NotificationTile(
                  title: '학과',
                  description: '현재 설정된 학과로 알림을 받을 수 있습니다.',
                  topic: 'major-notification',
                  getPreference: SharedPrefsManager().getMajorNotificationOn,
                  setPreference: SharedPrefsManager().setMajorNotificationOn,
                ),
                const SizedBox(height: 8),
                NotificationTile(
                  title: '국제처',
                  description: '국제처의 알림을 받을 수 있습니다.',
                  topic: 'INTERNATIONAL',
                  getPreference:
                      SharedPrefsManager().getInternationalNotificationOn,
                  setPreference:
                      SharedPrefsManager().setInternationalNotificationOn,
                ),
                const SizedBox(height: 8),
                NotificationTile(
                  title: 'SW중심대학사업단',
                  description: 'SW중심대학사업단의 알림을 받을 수 있습니다.',
                  topic: 'SWUNIV',
                  getPreference: SharedPrefsManager().getSWUnivNotificationOn,
                  setPreference: SharedPrefsManager().setSWUnivNotificationOn,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
