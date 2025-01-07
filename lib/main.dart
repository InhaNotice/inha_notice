import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

// Import screens
import 'screens/bottom_navigation/home_page.dart';
import 'screens/bottom_navigation/bookmark_page.dart';
import 'screens/bottom_navigation/search_page.dart';
import 'screens/bottom_navigation/more_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await _initializeStorage();
  runApp(const MyApp());
}

Future<void> _initializeStorage() async {
  final directory = await getApplicationDocumentsDirectory();
  final storageDir = Directory('${directory.path}/storage');
  if (!await storageDir.exists()) {
    await storageDir.create();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '인하공지',
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
    const HomePage(), // 기존 공지사항 탭
    const SearchPage(), // 검색 화면
    const BookmarkPage(), // 북마크 화면
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
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: '',
          ),
        ],
      ),
    );
  }
}