import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/bottom_navigation/more/major_setting_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting_page.dart';
import 'package:inha_notice/screens/web_page.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/widgets/themed_app_bar.dart';

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
              Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '공지사항',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Theme.of(context).defaultColor,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MajorSettingPage(),
                    ),
                  );
                },
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.school_outlined,
                              size: 20,
                              color: Theme.of(context).iconTheme.color),
                          const SizedBox(width: 8),
                          Text(
                            '학과 설정',
                            style: TextStyle(
                              fontFamily: Font.kDefaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color ??
                                  Theme.of(context).defaultColor,
                            ),
                          )
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 16,
                          color:
                              Theme.of(context).iconTheme.color), // 우측 아이콘 추가
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationSettingPage(),
                    ),
                  );
                },
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notifications_outlined,
                              size: 20,
                              color: Theme.of(context).iconTheme.color),
                          const SizedBox(width: 8),
                          Text(
                            '알림 설정',
                            style: TextStyle(
                              fontFamily: Font.kDefaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color ??
                                  Theme.of(context).defaultColor,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Theme.of(context).iconTheme.color),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  child: Divider(
                      color: Theme.of(context).dividerColor, thickness: 2.0)),
              Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '앱 정보',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Theme.of(context).defaultColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.rocket_launch_outlined,
                            size: 20, color: Theme.of(context).iconTheme.color),
                        const SizedBox(width: 8),
                        Text(
                          '앱 버전',
                          style: TextStyle(
                            fontFamily: Font.kDefaultFont,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Theme.of(context).defaultColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _appVersion,
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Theme.of(context).defaultColor,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebPage(url: _featuresUrl),
                    ),
                  );
                },
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star_outline_outlined,
                              size: 20,
                              color: Theme.of(context).iconTheme.color),
                          const SizedBox(width: 8),
                          Text(
                            '새로운 내용',
                            style: TextStyle(
                              fontFamily: Font.kDefaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color ??
                                  Theme.of(context).defaultColor,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Theme.of(context).iconTheme.color),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebPage(url: _aboutTeamUrl),
                    ),
                  );
                },
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people_outline_outlined,
                              size: 20,
                              color: Theme.of(context).iconTheme.color),
                          const SizedBox(width: 8),
                          Text(
                            '인하공지 팀',
                            style: TextStyle(
                              fontFamily: Font.kDefaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color ??
                                  Theme.of(context).defaultColor,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Theme.of(context).iconTheme.color),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebPage(url: _personalInformationUrl),
                    ),
                  );
                },
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.privacy_tip_outlined,
                              size: 20,
                              color: Theme.of(context).iconTheme.color),
                          const SizedBox(width: 8),
                          Text(
                            '개인정보 처리방침',
                            style: TextStyle(
                              fontFamily: Font.kDefaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color ??
                                  Theme.of(context).defaultColor,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Theme.of(context).iconTheme.color),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebPage(url: _termsAndConditionsOfServiceUrl),
                    ),
                  );
                },
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.checklist_rtl_outlined,
                              size: 20,
                              color: Theme.of(context).iconTheme.color),
                          const SizedBox(width: 8),
                          Text(
                            '서비스 이용약관',
                            style: TextStyle(
                              fontFamily: Font.kDefaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color ??
                                  Theme.of(context).defaultColor,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 16,
                          color:
                              Theme.of(context).iconTheme.color), // 우측 아이콘 추가
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebPage(url: _introduceAppUrl),
                    ),
                  );
                },
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 20,
                              color: Theme.of(context).iconTheme.color),
                          const SizedBox(width: 8),
                          Text(
                            '앱 소개',
                            style: TextStyle(
                              fontFamily: Font.kDefaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color ??
                                  Theme.of(context).defaultColor,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Theme.of(context).iconTheme.color),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebPage(url: _questionsAndAnswersUrl),
                    ),
                  );
                },
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.question_answer_outlined,
                              size: 20,
                              color: Theme.of(context).iconTheme.color),
                          const SizedBox(width: 8),
                          Text(
                            'Q&A',
                            style: TextStyle(
                              fontFamily: Font.kDefaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color ??
                                  Theme.of(context).defaultColor,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Theme.of(context).iconTheme.color),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
