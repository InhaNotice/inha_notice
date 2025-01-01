import 'package:flutter/material.dart';

// Import screens
import 'screens/bottom_navigation_bar/main_notice_page.dart';
import 'screens/bottom_navigation_bar/subscription_page.dart';
import 'screens/bottom_navigation_bar/bookmark_page.dart';
import 'screens/bottom_navigation_bar/search_page.dart';
import 'screens/bottom_navigation_bar/more_page.dart';

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
    const MainNoticePage(), // 기존 공지사항 탭
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
        backgroundColor: const Color(0xFF292929), // 배경 색상
        selectedItemColor: Colors.white, // 선택된 아이콘 및 텍스트 색상
        unselectedItemColor: Colors.white60, // 선택되지 않은 아이콘 및 텍스트 색상
        selectedLabelStyle: const TextStyle( // 선택된 텍스트 스타일
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle( // 선택되지 않은 텍스트 스타일
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.normal,
          fontSize: 13,
        ),
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