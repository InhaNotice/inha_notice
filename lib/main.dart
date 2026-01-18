/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-18
 */

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/config/app_theme_type.dart';
import 'package:inha_notice/core/config/firebase_options.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/features/notification/data/datasources/firebase_remote_data_source.dart';
import 'package:inha_notice/screens/onboarding/onboarding_screen.dart';
import 'package:inha_notice/utils/read_notice/read_notice_manager.dart';
import 'package:inha_notice/utils/recent_search/recent_search_manager.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:logger/logger.dart';

import 'core/config/app_bloc_observer.dart';
import 'features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'injection_container.dart' as di;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier(ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  await di.init();

  await _initializeApp();
  // FCM 초기화는 백그라운드에서 진행
  await _initializeFirebase();
  // 테마 설정 불러오기
  await _initializeThemeSetting();

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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: '인하공지',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          navigatorKey: navigatorKey,
          home: const OnboardingScreen(),
        );
      },
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
      di.sl<BookmarkLocalDataSource>().initialize(),
      ReadNoticeManager.initialize(),
      RecentSearchManager.initialize(),
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

  // Firebase 서비스 초기화
  await FirebaseRemoteDataSource().initialize();

  return app;
}

/// **테마 설정 불러오기**
Future<void> _initializeThemeSetting() async {
  final Logger logger = Logger();
  try {
    final String userThemeSetting = SharedPrefsManager()
            .getValue<String>(SharedPrefKeys.kUserThemeSetting) ??
        AppThemeType.system.text;

    if (userThemeSetting == AppThemeType.light.text) {
      themeModeNotifier.value = ThemeMode.light;
      return;
    }

    if (userThemeSetting == AppThemeType.dark.text) {
      themeModeNotifier.value = ThemeMode.dark;
      return;
    }

    themeModeNotifier.value = ThemeMode.system;
  } catch (e) {
    logger.e('❌ 테마 설정 불러오기 실패: $e');
  }
}
