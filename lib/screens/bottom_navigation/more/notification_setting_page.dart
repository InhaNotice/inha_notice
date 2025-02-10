/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-10
 */
import 'package:flutter/material.dart';
import 'package:inha_notice/firebase/firebase_service.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/widgets/blocking_dialog.dart';
import 'package:inha_notice/widgets/themed_app_bar.dart';
import 'package:inha_notice/widgets/themed_snackbar.dart';

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
  final String _academicTopic = 'all-notices';
  bool _isAcademicNotificationOn = false;
  bool _isMajorNotificationOn = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  /// **저장된 알림 설정 불러오기**
  Future<void> _loadNotificationPreference() async {
    setState(() {
      _isAcademicNotificationOn =
          SharedPrefsManager().getAcademicNotificationOn();
      _isMajorNotificationOn = SharedPrefsManager().getMajorNotificationOn();
    });
  }

  /// **학사 알림 설정 변경 및 저장**
  Future<void> _toggleAcademicNotification(bool value) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      BlockingDialog.show(context);
    });

    try {
      if (value) {
        await FirebaseService().subscribeToTopic(_academicTopic);
      } else {
        await FirebaseService().unsubscribeFromTopic(_academicTopic);
      }

      await SharedPrefsManager().setAcademicNotificationOn(value);

      setState(() {
        _isAcademicNotificationOn = value;
      });
      if (mounted) {
        ThemedSnackbar.showSnackbar(
            context, value ? '학사 알림이 활성화되었습니다.' : '학사 알림이 비활성화되었습니다.');
      }
    } catch (e) {
      if (mounted) {
        ThemedSnackbar.showSnackbar(context, '알림 설정 중 오류가 발생했습니다.');
      }
    } finally {
      if (mounted) {
        BlockingDialog.dismiss(context);
      }
      setState(() {
        _isProcessing = false;
      });
    }
  }

  /// 학과 알림 설정 변경 및 저장
  Future<void> _toggleMajorNotification(bool value) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      BlockingDialog.show(context);
    });

    try {
      final majorKey = SharedPrefsManager().getMajorKey();
      if (majorKey == null) {
        if (mounted) {
          BlockingDialog.dismiss(context);
        }
        if (mounted) {
          ThemedSnackbar.showSnackbar(context, '학과를 먼저 설정해주세요!');
        }
        return;
      }

      if (value) {
        await FirebaseService().updateMajorSubscription();
      } else {
        await FirebaseService().unsubscribeFromTopic(majorKey);
      }

      await SharedPrefsManager().setMajorNotificationOn(value);

      setState(() {
        _isMajorNotificationOn = value;
      });
      if (mounted) {
        ThemedSnackbar.showSnackbar(
            context, value ? '학과 알림이 활성화되었습니다.' : '학과 알림이 비활성화되었습니다.');
      }
    } catch (e) {
      if (mounted) {
        ThemedSnackbar.showSnackbar(context, '학과 알림 설정 중 오류가 발생했습니다.');
      }
    } finally {
      if (mounted) {
        BlockingDialog.dismiss(context);
      }
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThemedAppBar(title: '알림 설정', titleSize: 20, isCenter: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Theme.of(context).boxBorderColor,
                    width: 0.7,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 학사 알림 설정
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '학사 알림 설정',
                          style: TextStyle(
                            fontFamily: Font.kDefaultFont,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                        Switch(
                          value: _isAcademicNotificationOn,
                          onChanged: _toggleAcademicNotification,
                          activeColor: Theme.of(context).primaryColorLight,
                        ),
                      ],
                    ),
                    Text(
                      '인하대학교 공식 사이트의 알림을 받을 수 있습니다.',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Theme.of(context).defaultColor,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// 학과 알림 설정
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '학과 알림 설정',
                          style: TextStyle(
                            fontFamily: Font.kDefaultFont,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                        Switch(
                          value: _isMajorNotificationOn,
                          onChanged: _toggleMajorNotification,
                          activeColor: Theme.of(context).primaryColorLight,
                        ),
                      ],
                    ),

                    Text(
                      '현재 설정된 학과로 알림을 받을 수 있습니다.',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Theme.of(context).defaultColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
