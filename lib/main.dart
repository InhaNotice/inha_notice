import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inha_notice/firebase/firebase_service.dart';
import 'package:inha_notice/screens/onboarding/onboarding_screen.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/bookmark_manager.dart';
import 'package:inha_notice/utils/read_notice_manager.dart';
import 'package:inha_notice/utils/shared_prefs_manager.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase/firebase_options.dart';

SharedPreferences? _prefs;
Future<FirebaseApp>? _firebaseInitFuture;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeApp();
  _firebaseInitFuture = _initializeFirebase(); // 한 번만 초기화
  await _firebaseInitFuture;

  runApp(const MyApp());
}

/// MyApp 위젯 정의
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// MyAppState 클래스 정의
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '인하공지',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: const OnboardingScreen(),
    );
  }
}

/// 앱 초기화 함수
Future<void> _initializeApp() async {
  await dotenv.load(fileName: ".env");
  await SharedPrefsManager().initialize();
  await _initializeStorage();
}

/// 스토리지 초기화 함수
Future<void> _initializeStorage() async {
  final Logger logger = Logger();
  try {
    await Future.wait([
      BookmarkManager.initDatabase(),
      ReadNoticeManager.initDatabase(),
    ]);
  } catch (e, stackTrace) {
    logger.e('Error initializing storage: $e');
    logger.e('Stack trace: $stackTrace');
  }
}

/// Firebase 초기화 함수 (싱글톤 적용)
Future<FirebaseApp> _initializeFirebase() async {
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase 서비스 초기화 및 토픽 구독
  await FirebaseService().initialize();

  return app;
}
