/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/config/app_theme_type.dart';
import 'package:inha_notice/core/config/firebase_options.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/app_logger.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/notice/data/datasources/read_notice_local_data_source.dart';
import 'package:inha_notice/features/notification/data/datasources/firebase_remote_data_source.dart';
import 'package:inha_notice/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:inha_notice/features/search/data/datasources/recent_search_manager.dart';

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

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    await Future.wait([
      di.sl<BookmarkLocalDataSource>().initialize(),
      di.sl<SharedPrefsManager>().initialize(),
      di.sl<FirebaseRemoteDataSource>().initialize(),
      ReadNoticeLocalDataSource.initialize(),
      RecentSearchManager.initialize(),
    ]);
  } catch (e, stackTrace) {
    AppLogger.e('앱 초기화 작업 중 일부 실패: $e');
    AppLogger.e('$stackTrace');
  }

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
          home: const OnboardingPage(),
        );
      },
    );
  }
}

/// **테마 설정 불러오기**
Future<void> _initializeThemeSetting() async {
  try {
    final String userThemeSetting = di
            .sl<SharedPrefsManager>()
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
    AppLogger.e('테마 설정 불러오기 실패 (기본값 적용): $e');
    themeModeNotifier.value = ThemeMode.system;
  }
}
