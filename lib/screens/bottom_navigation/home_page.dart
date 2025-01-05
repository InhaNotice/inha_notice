import 'package:flutter/material.dart';

import 'package:inha_notice/screens/tab_bar/international_notice.dart';
import 'package:inha_notice/screens/tab_bar/library_notice.dart';
import 'package:inha_notice/screens/tab_bar/recruitment_notice.dart';
import 'package:inha_notice/screens/tab_bar/scholarship_notice.dart';
import 'package:inha_notice/screens/tab_bar/whole_notice.dart';
import 'package:inha_notice/screens/tab_bar/major_notice.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // 두 개의 탭
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF222222), // AppBar 배경색
          title: const Align(
            alignment: Alignment.centerLeft, // 제목을 왼쪽 정렬
            child: Text(
              '인하공유',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                color: Color(0xFFBAB6B6), // 제목 글자 색상 BAB6B6
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              color: const Color(0xFFBAB6B6), // 알림 버튼 색상
              onPressed: () {
                // 알림 버튼 동작 추가
                print('알림 버튼 클릭됨');
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color(0xFF12B8FF), // 탭 선택 시 하단 표시줄 색상
            labelColor: Color(0xFF12B8FF), // 선택된 탭 텍스트 색상 12B8FF
            unselectedLabelColor: Color(0xFFBAB6B6), // 선택되지 않은 탭 텍스트 색상 BAB6B6
            labelStyle: TextStyle( // 선택된 탭 텍스트 스타일
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            unselectedLabelStyle: TextStyle( // 선택되지 않은 탭 텍스트 스타일
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