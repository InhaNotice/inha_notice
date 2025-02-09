import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inha_notice/firebase/firebase_service.dart';
import 'package:inha_notice/screens/onboarding/onboarding_screen.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/bookmark/bookmark_manager.dart';
import 'package:inha_notice/utils/read_notice/read_notice_manager.dart';
import 'package:inha_notice/utils/recent_search_topics_manager.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:logger/logger.dart';

import 'firebase/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeApp();
  // FCM 초기화는 백그라운드에서 진행
  _initializeFirebase();

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
      navigatorKey: navigatorKey,
      home: const OnboardingScreen(),
    );
  }
}

/// **앱 초기화**
Future<void> _initializeApp() async {
  await dotenv.load(fileName: ".env");
  await _initializeStorage();
}

/// **데이터베이스 초기화**
Future<void> _initializeStorage() async {
  final Logger logger = Logger();
  try {
    await Future.wait([
      SharedPrefsManager().initialize(),
      BookmarkManager.initialize(),
      ReadNoticeManager.initialize(),
      RecentSearchTopicsManager.initialize(),
    ]);
  } catch (e, stackTrace) {
    logger.e('Error initializing storage: $e');
    logger.e('Stack trace: $stackTrace');
  }
}

/// **Firebase 초기화 함수 (싱글톤 적용)**
Future<FirebaseApp> _initializeFirebase() async {
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase 서비스 초기화 및 토픽 구독
  await FirebaseService().initialize();

  return app;
}
