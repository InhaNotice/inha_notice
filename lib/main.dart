import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/screens/onboarding/onboarding_screen.dart';
import 'firebase/firebase_options.dart';
import 'package:inha_notice/utils/bookmark_manager.dart';
import 'package:inha_notice/utils/major_storage.dart';
import 'package:inha_notice/utils/read_notice_manager.dart';

// Firebase 메시지 백그라운드 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeApp();
  await _initializeFirebase();

  runApp(const MyApp());
}

/// 앱 초기화 함수
Future<void> _initializeApp() async {
  await dotenv.load(fileName: ".env");
  await _initializeStorage();
}

/// Firebase 초기화 함수
Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 알림 권한 요청
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // 모든 사용자가 'all-users' 토픽을 구독하도록 설정
  try {
    await messaging.subscribeToTopic('all-users');
    print("✅ Successfully subscribed to 'all-users' topic");
  } catch (e) {
    print("🚨 Error subscribing to 'all-users' topic: $e");
  }

  // Firebase 메시지 리스너
  FirebaseMessaging.onMessage.listen(_onForegroundMessageHandler);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  try {
    String? apnsToken = await messaging.getAPNSToken();
    if (apnsToken != null) {
      print('APNS Token and FCM Token were successfully created.');
    } else {
      // APNS 토큰은 공용 와이파이로 연결된 시뮬레이터에서는 불러올 수 없습니다.
      // 시뮬레이터로 실행시 반드시 핫스팟으로 연결해주세요.
      print(
          'APNS Token not set. Make sure the device has network access and notifications are enabled.');
    }
  } catch (e) {
    print('Error fetching APNS token: $e');
  }
}

/// Firebase 알림 메시지 핸들러
void _onForegroundMessageHandler(RemoteMessage message) {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
  }
}

/// 스토리지 초기화 함수
Future<void> _initializeStorage() async {
  try {
    await Future.wait([
      MajorStorage.initDatabase(),
      BookmarkManager.initDatabase(),
      ReadNoticeManager.initDatabase(),
    ]);
  } catch (e, stackTrace) {
    debugPrint('Error initializing storage: $e');
    debugPrint('Stack trace: $stackTrace');
  }
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
