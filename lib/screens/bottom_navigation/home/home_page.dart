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
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/bottom_navigation/more/notification_setting_page.dart';
import 'package:inha_notice/screens/notice_board/absolute_style_notice_board.dart';
import 'package:inha_notice/screens/notice_board/relative_style_notice_board.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/widgets/search_result_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '인',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 16,
                        color: Theme.of(context).fixedBlueText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '하',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 16,
                        color: Theme.of(context).fixedLightGreyText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '공',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 16,
                        color: Theme.of(context).fixedBlueText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '지',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 16,
                        color: Theme.of(context).fixedLightGreyText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.notifications_outlined,
                    color: Theme.of(context).iconTheme.color),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationSettingPage()),
                  );
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48), // `TabBar` 높이 조절
            child: Theme(
              data: Theme.of(context).copyWith(
                splashFactory: NoSplash.splashFactory, // 물결 효과 제거
                highlightColor: Colors.transparent, // 하이라이트 효과 제거
              ),
              child: const TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                indicatorColor: Color(0xFF12B8FF),
                labelColor: Color(0xFF12B8FF),
                unselectedLabelColor: Color(0xFFBAB6B6),
                labelStyle: TextStyle(
                  fontFamily: Font.kDefaultFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: Font.kDefaultFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                tabs: [
                  Tab(text: '학사'),
                  Tab(text: '학과'),
                  Tab(text: '장학'),
                  Tab(text: '채용'),
                  Tab(text: '정석'),
                  Tab(text: '국제처'),
                  Tab(text: 'SW중심대학'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            AbsoluteStyleNoticeBoard(noticeType: 'WHOLE'),
            AbsoluteStyleNoticeBoard(noticeType: 'MAJOR'),
            SearchResultPage(query: '장학', isSearchResultPage: false),
            SearchResultPage(query: '채용', isSearchResultPage: false),
            RelativeStyleNoticeBoard(noticeType: 'LIBRARY'),
            AbsoluteStyleNoticeBoard(noticeType: 'INTERNATIONAL'),
            AbsoluteStyleNoticeBoard(noticeType: 'SWUNIV'),
          ],
        ),
      ),
    );
  }
}
