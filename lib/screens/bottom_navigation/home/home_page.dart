import 'package:flutter/material.dart';

import 'package:inha_notice/screens/notices_categories/international_notice.dart';
import 'package:inha_notice/screens/notices_categories/library_notice.dart';
import 'package:inha_notice/screens/notices_categories/recruitment_notice.dart';
import 'package:inha_notice/screens/notices_categories/scholarship_notice.dart';
import 'package:inha_notice/screens/notices_categories/whole_notice_page.dart';
import 'package:inha_notice/screens/notices_categories/major_notice.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '인',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      color: Color(0xFF12B8FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '하',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      color: Color(0xFFBAB6B6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '공',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      color: Color(0xFF12B8FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '지',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      color: Color(0xFFBAB6B6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              color: Theme.of(context).iconTheme.color,
              onPressed: () {
                print('알림 버튼 클릭됨');
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color(0xFF12B8FF),
            labelColor: Color(0xFF12B8FF),
            unselectedLabelColor: Color(0xFFBAB6B6),
            labelStyle: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            tabs: [
              Tab(text: '학사'),
              Tab(text: '학과'),
              Tab(text: '장학'),
              Tab(text: '채용'),
              Tab(text: '정석'),
              Tab(text: '국제')
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WholeNoticePage(),
            MajorNoticePage(),
            ScholarshipNoticePage(),
            RecruitmentNoticePage(),
            LibraryNoticePage(),
            InternationalNoticePage(),
          ],
        ),
      ),
    );
  }
}
