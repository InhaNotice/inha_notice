/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-26
 */
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inha_notice/firebase/firebase_service.dart';
import 'package:inha_notice/screens/bottom_navigation/bookmark/bookmark_page.dart';
import 'package:inha_notice/screens/bottom_navigation/home/home_page.dart';
import 'package:inha_notice/screens/bottom_navigation/more/more_page.dart';
import 'package:inha_notice/screens/bottom_navigation/search/search_page.dart';
import 'package:inha_notice/utils/read_notice/read_notice_manager.dart';
import 'package:inha_notice/widgets/navigation/web_navigator.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const BookmarkPage(),
    const MorePage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadWebPage();
  }

  Future<void> _loadWebPage() async {
    RemoteMessage? initialMessage =
        await FirebaseService().getInitialNotification();
    final String? initialLink = initialMessage?.data['link'];

    // 읽은 공지로 추가 (백그라운드 진행)
    if (initialMessage != null && initialMessage.data.containsKey('id')) {
      ReadNoticeManager.addReadNotice(initialMessage.data['id']);
    }

    if (initialLink != null) {
      if (mounted) {
        WebNavigator.navigate(context: context, url: initialLink);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory, // 물결 효과 제거
            highlightColor: Colors.transparent, // 하이라이트 효과 제거
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontSize: 12, // 선택된 탭 글자 크기
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 10, // 선택되지 않은 탭 글자 크기
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '검색',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: '북마크',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: '더보기',
              ),
            ],
          ),
        ));
  }
}
