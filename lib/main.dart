import 'package:flutter/material.dart';

// Import screens
import 'screens/left_notice.dart';
import 'screens/right_notice.dart';
import 'screens/subscription_page.dart';
import 'screens/bookmark_page.dart';
import 'screens/search_page.dart';
import 'screens/more_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSE Notices',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BottomNavBarPage(),
    );
  }
}

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  int _currentIndex = 0;

  // 하단 탭별 화면
  final List<Widget> _pages = [
    const MainPage(), // 기존 공지사항 탭
    const SubscriptionPage(), // 구독 화면
    const BookmarkPage(), // 북마크 화면
    const SearchPage(), // 검색 화면
    const MorePage(), // 더보기 화면
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // 현재 선택된 탭 인덱스 업데이트
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '공지사항',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: '구독',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '북마크',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: '더보기',
          ),
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 두 개의 탭
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notice Board'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'SW Univ Notices'),
              Tab(text: 'CSE Notices'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LeftNoticePage(), // 왼쪽 탭
            RightNoticePage(), // 오른쪽 탭
          ],
        ),
      ),
    );
  }
}