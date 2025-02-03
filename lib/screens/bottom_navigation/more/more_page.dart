import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/bottom_navigation/more/major_setting_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting_page.dart';
import 'package:inha_notice/themes/theme.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: false,
        title: Text(
          '더보기',
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).textTheme.bodyLarge?.color ??
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
                      Text(
                        '학과 설정',
                        style: TextStyle(
                          fontFamily: Font.kDefaultFont,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                                  Theme.of(context).defaultColor,
                        ),
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
                      Text(
                        '알림 설정',
                        style: TextStyle(
                          fontFamily: Font.kDefaultFont,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color ??
                                  Theme.of(context).defaultColor,
                        ),
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
                      '피드백',
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
                    Text(
                      '피드백 보내기',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Theme.of(context).defaultColor,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: Theme.of(context).iconTheme.color),
                  ],
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
                      '1.0.1',
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
                        Icon(Icons.star_outline_outlined,
                            size: 20, color: Theme.of(context).iconTheme.color),
                        const SizedBox(width: 8),
                        Text(
                          '새로운 내용',
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
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: Theme.of(context).iconTheme.color),
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
                        Icon(Icons.privacy_tip_outlined,
                            size: 20, color: Theme.of(context).iconTheme.color),
                        const SizedBox(width: 8),
                        Text(
                          '개인정보 처리방침',
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
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: Theme.of(context).iconTheme.color),
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
                        Icon(Icons.checklist_rtl_outlined,
                            size: 20, color: Theme.of(context).iconTheme.color),
                        const SizedBox(width: 8),
                        Text(
                          '서비스 이용약관',
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
                    Icon(Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context).iconTheme.color), // 우측 아이콘 추가
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
                        Icon(Icons.source_outlined,
                            size: 20, color: Theme.of(context).iconTheme.color),
                        const SizedBox(width: 8),
                        Text(
                          '사용된 오픈소스',
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
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: Theme.of(context).iconTheme.color),
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
                        Icon(Icons.people_outline_outlined,
                            size: 20, color: Theme.of(context).iconTheme.color),
                        const SizedBox(width: 8),
                        Text(
                          '인공 팀',
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
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: Theme.of(context).iconTheme.color),
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
