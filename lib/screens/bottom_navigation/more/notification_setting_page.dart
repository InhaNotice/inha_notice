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
import 'package:inha_notice/widgets/themed_app_bar.dart';
import 'package:logger/logger.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  final String _academicTopic = 'all-notices';
  final logger = Logger();
  bool _isAcademicNotificationOn = false;
  bool _isMajorNotificationOn = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  /// 저장된 알림 설정 불러오기
  Future<void> _loadNotificationPreference() async {
    setState(() {
      _isAcademicNotificationOn =
          SharedPrefsManager().getAcademicNotificationOn();
      _isMajorNotificationOn = SharedPrefsManager().getMajorNotificationOn();
    });
  }

  /// 학사 알림 설정 변경 및 저장
  Future<void> _toggleAcademicNotification(bool value) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _showLoadingDialog();
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
      _showSnackbar(value ? '학사 알림이 활성화되었습니다.' : '학사 알림이 비활성화되었습니다.');
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      logger.e("❌ Error updating academic notification: $e");
      _showSnackbar('알림 설정 중 오류가 발생했습니다.');
    } finally {
      _dismissLoadingDialog();
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
      _showLoadingDialog();
    });

    try {
      final majorKey = SharedPrefsManager().getMajorKey();
      if (majorKey == null) {
        _dismissLoadingDialog();
        _showSnackbar('학과를 먼저 설정해주세요!');
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
      _showSnackbar(value ? '학과 알림이 활성화되었습니다.' : '학과 알림이 비활성화되었습니다.');
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      logger.e("❌ Error updating major notification: $e");
      _showSnackbar('학과 알림 설정 중 오류가 발생했습니다.');
    } finally {
      _dismissLoadingDialog();
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // 사용자가 닫을 수 없도록 설정
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        );
      },
    );
  }

  /// 다이얼로그 닫기
  void _dismissLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).snackBarTextColor,
          ),
        ),
        backgroundColor: Theme.of(context).snackBarBackgroundColor,
      ),
    );
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
                  borderRadius: BorderRadius.circular(10.0), // 둥근 테두리
                  border: Border.all(
                    color: Theme.of(context).boxBorderColor, // 검정 테두리
                    width: 0.7, // 얇은 선
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
