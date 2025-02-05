import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/screens/notice_board/library_notice.dart';
import 'package:inha_notice/screens/notice_board/notice_board.dart';
import 'package:inha_notice/screens/notice_board/search_style/recruitment_notice.dart';
import 'package:inha_notice/screens/notice_board/search_style/scholarship_notice.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
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
                      fontFamily: Font.kDefaultFont,
                      fontSize: 16,
                      color: Color(0xFF12B8FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '하',
                    style: TextStyle(
                      fontFamily: Font.kDefaultFont,
                      fontSize: 16,
                      color: Color(0xFFBAB6B6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '공',
                    style: TextStyle(
                      fontFamily: Font.kDefaultFont,
                      fontSize: 16,
                      color: Color(0xFF12B8FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '지',
                    style: TextStyle(
                      fontFamily: Font.kDefaultFont,
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
                  Tab(text: '국제'),
                  Tab(text: 'SW중심대학'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            NoticeBoard(noticeType: 'WHOLE'),
            NoticeBoard(noticeType: 'MAJOR'),
            ScholarshipNoticePage(),
            RecruitmentNoticePage(),
            LibraryNoticeBoard(),
            NoticeBoard(noticeType: 'INTERNATIONAL'),
            NoticeBoard(noticeType: 'SWUNIV'),
          ],
        ),
      ),
    );
  }
}
