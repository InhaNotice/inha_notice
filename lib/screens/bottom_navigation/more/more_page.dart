/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-03-01
 */
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inha_notice/screens/bottom_navigation/more/cache_deletetion/cache_deletion_tile.dart';
import 'package:inha_notice/screens/bottom_navigation/more/custom_tab_bar_page/custom_tab_bar_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/more_page_titles/more_navigation_tile.dart';
import 'package:inha_notice/screens/bottom_navigation/more/more_page_titles/more_non_navigation_tile.dart';
import 'package:inha_notice/screens/bottom_navigation/more/more_page_titles/more_title_tile.dart';
import 'package:inha_notice/screens/bottom_navigation/more/more_page_titles/more_web_navigation_tile.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting/notification_setting_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/theme_preference/theme_preference_tile.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_app_bar.dart';

import 'custom_license/custom_licenses_page.dart';

/// **MorePage**
/// 이 클래스는 더보기 페이지를 구현하는 클래스입니다.
class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  late String _featuresUrl;
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
              MoreTitleTile(text: '공지사항', fontSize: 16),
              MoreNavigationTile(
                title: '나만의 탭 설정',
                icon: Icons.tab_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomTabBarPage(),
                    ),
                  );
                },
              ),
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
              MoreTitleTile(text: '이용 안내', fontSize: 16),
              MoreWebNavigationTile(
                  title: '새로운 내용',
                  url: _featuresUrl,
                  icon: Icons.star_outline_outlined),
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
                  title: 'FAQ',
                  url: _questionsAndAnswersUrl,
                  icon: Icons.question_answer_outlined),
              // 구분선
              SizedBox(
                  width: double.infinity,
                  child: Divider(
                      color: Theme.of(context).dividerColor, thickness: 2.0)),
              MoreTitleTile(text: '앱 설정', fontSize: 16),
              MoreNonNavigationTile(
                  title: '앱 버전',
                  description: _appVersion,
                  icon: Icons.rocket_launch_outlined),
              ThemePreferenceTile(
                title: '테마',
                icon: Icons.palette_outlined,
              ),
              CacheDeletionTile(
                title: '캐시 삭제',
                icon: Icons.cleaning_services_outlined,
              ),
              // 구분선
              SizedBox(
                  width: double.infinity,
                  child: Divider(
                      color: Theme.of(context).dividerColor, thickness: 2.0)),
              MoreTitleTile(text: '기타', fontSize: 16),
              MoreNavigationTile(
                title: '사용된 오픈소스',
                icon: Icons.source_outlined,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => CustomLicensePage()),
                  );
                },
              ),
              SizedBox(
                  width: double.infinity,
                  child: Divider(
                      color: Theme.of(context).dividerColor, thickness: 2.0)),
              MoreTitleTile(text: 'Copyright (c) 2025 INGONG', fontSize: 12),
            ],
          ),
        ),
      ),
    );
  }
}
