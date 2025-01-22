import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/screens/onboarding/onboarding_screen.dart';
import 'firebase/firebase_options.dart';

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
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  // Firebase 메시지 리스너
  FirebaseMessaging.onMessage.listen(_onForegroundMessageHandler);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
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
  final directory = await getApplicationDocumentsDirectory();
  final storageDir = Directory('${directory.path}/storage');
  if (!await storageDir.exists()) {
    await storageDir.create();
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