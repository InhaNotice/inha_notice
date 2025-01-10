import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

import 'themes/theme.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '인하공지',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: BottomNavBarPage(),
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
    const HomePage(),
    const SearchPage(),
    const BookmarkPage(),
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
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
    );
  }
}