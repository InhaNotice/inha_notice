import 'package:flutter/material.dart';
import 'package:inha_notice/firebase/firebase_service.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/shared_prefs_manager.dart';

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
    if (value) {
      await FirebaseService().subscribeToTopic(_academicTopic);
    } else {
      await FirebaseService().unsubscribeFromTopic(_academicTopic);
    }
    await SharedPrefsManager().setAcademicNotificationOn(value);
    setState(() {
      _isAcademicNotificationOn = value;
    });
  }

  /// 학과 알림 설정 변경 및 저장
  Future<void> _toggleMajorNotification(bool value) async {
    /// 학과 키 확인
    final majorKey = SharedPrefsManager().getMajorKey();

    if (majorKey == null) {
      // 학과가 설정되지 않은 경우 토글을 차단하고 스낵바 경고 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '학과를 먼저 설정해주세요!',
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
      return;
    }

    // 학과가 설정된 경우
    // true: 이전학과 존재시 구독 해제 및 현재 학과 구독 진행
    // false: 현재 학과 구독 해제
    if (value) {
      await FirebaseService().updateMajorSubscription();
    } else {
      await FirebaseService().unsubscribeFromTopic(majorKey);
    }

    /// 현재 설정값 저장
    await SharedPrefsManager().setMajorNotificationOn(value);

    setState(() {
      _isMajorNotificationOn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          '알림 설정',
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultColor,
          ),
        ),
      ),
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
