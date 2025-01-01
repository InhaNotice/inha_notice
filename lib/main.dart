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
        backgroundColor: const Color(0xFF292929), // 배경 색상
        selectedItemColor: Colors.white, // 선택된 아이콘 및 텍스트 색상
        unselectedItemColor: Colors.white60, // 선택되지 않은 아이콘 및 텍스트 색상
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
          backgroundColor: const Color(0xFF222222), // AppBar 배경색
          title: const Align(
            alignment: Alignment.centerLeft, // 제목을 왼쪽 정렬
            child: Text(
              'Notice Board',
              style: TextStyle(
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
            tabs: [
              Tab(text: '학사'),
              Tab(text: '학과'),
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