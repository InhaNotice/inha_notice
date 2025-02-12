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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inha_notice/screens/bottom_navigation/more/major_setting_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/titles/more_navigation_tile.dart';
import 'package:inha_notice/screens/bottom_navigation/more/titles/more_non_navigation_tile.dart';
import 'package:inha_notice/screens/bottom_navigation/more/titles/more_title_tile.dart';
import 'package:inha_notice/screens/bottom_navigation/more/titles/more_web_navigation_tile.dart';
import 'package:inha_notice/widgets/themed_app_bar.dart';

/// **MorePage**
/// 이 클래스는 더보기 페이지를 구현하는 클래스입니다.
class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  late String _featuresUrl;
  late String _aboutTeamUrl;
  late String _personalInformationUrl;
  late String _termsAndConditionsOfServiceUrl;
  late String _introduceAppUrl;
  late String _questionsAndAnswersUrl;
  late String _appVersion;

  @override
  void initState() {
    super.initState();
    _initializeWebPageUrls();
  }

  /// **웹 페이지 URL을 불러오기**
  void _initializeWebPageUrls() {
    _appVersion = dotenv.get('APP_VERSION');
    _featuresUrl = dotenv.get('FEATURES_URL');
    _aboutTeamUrl = dotenv.get('ABOUT_TEAM_URL');
    _personalInformationUrl = dotenv.get('PERSONAL_INFORMATION_URL');
    _termsAndConditionsOfServiceUrl =
        dotenv.get('TERMS_AND_CONDITIONS_OF_SERVICE_URL');
    _introduceAppUrl = dotenv.get('INTRODUCE_APP_URL');
    _questionsAndAnswersUrl = dotenv.get('QUESTIONS_AND_ANSWERS_URL');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThemedAppBar(title: '더보기', titleSize: 20, isCenter: false),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MoreTitleTile(title: '공지사항'),
              MoreNavigationTile(
                  title: '학과 설정',
                  icon: Icons.school_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MajorSettingPage(),
                      ),
                    );
                  }),
              MoreNavigationTile(
                  title: '알림 설정',
                  icon: Icons.notifications_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationSettingPage(),
                      ),
                    );
                  }),
              // 구분선
              SizedBox(
                  width: double.infinity,
                  child: Divider(
                      color: Theme.of(context).dividerColor, thickness: 2.0)),
              MoreTitleTile(title: '앱 정보'),
              MoreNonNavigationTile(
                  title: '앱 버전',
                  description: _appVersion,
                  icon: Icons.rocket_launch_outlined),
              MoreWebNavigationTile(
                  title: '새로운 내용',
                  url: _featuresUrl,
                  icon: Icons.star_outline_outlined),
              MoreWebNavigationTile(
                  title: '인공 팀',
                  url: _aboutTeamUrl,
                  icon: Icons.people_outline_outlined),
              MoreWebNavigationTile(
                  title: '개인정보 처리방침',
                  url: _personalInformationUrl,
                  icon: Icons.privacy_tip_outlined),
              MoreWebNavigationTile(
                  title: '서비스 이용약관',
                  url: _termsAndConditionsOfServiceUrl,
                  icon: Icons.checklist_rtl_outlined),
              MoreWebNavigationTile(
                  title: '앱 소개',
                  url: _introduceAppUrl,
                  icon: Icons.info_outline),
              MoreWebNavigationTile(
                  title: 'Q&A',
                  url: _questionsAndAnswersUrl,
                  icon: Icons.question_answer_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
