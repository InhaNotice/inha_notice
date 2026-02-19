/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/config/app_theme_type.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/more/presentation/widgets/theme_mode_selection_dialog.dart';
import 'package:inha_notice/features/more/presentation/widgets/theme_preference_tile.dart';
import 'package:inha_notice/injection_container.dart' as di;
import 'package:inha_notice/main.dart';

import '../../../support/widget_test_pump_app.dart';

class _FakeSharedPrefsManager extends SharedPrefsManager {
  _FakeSharedPrefsManager() : super(null);

  final Map<String, dynamic> values = {};

  @override
  T? getValue<T>(String key) {
    final value = values[key];
    if (value is T) return value;
    return null;
  }

  @override
  Future<void> setValue<T>(String key, T value) async {
    values[key] = value;
  }
}

void main() {
  group('ThemePreferenceTile 위젯 테스트', () {
    late _FakeSharedPrefsManager prefs;
    late ThemeMode originalThemeMode;

    setUp(() async {
      await di.sl.reset();
      originalThemeMode = themeModeNotifier.value;

      prefs = _FakeSharedPrefsManager()
        ..values[SharedPrefKeys.kUserThemeSetting] = AppThemeType.system.text;
      di.sl.registerLazySingleton<SharedPrefsManager>(() => prefs);
    });

    tearDown(() async {
      themeModeNotifier.value = originalThemeMode;
      await di.sl.reset();
    });

    testWidgets('초기 설명을 화면에 렌더링한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const ThemePreferenceTile(
          title: '테마',
          icon: Icons.palette_outlined,
        ),
      );

      expect(find.text('테마'), findsOneWidget);
      expect(find.text(AppThemeType.system.text), findsOneWidget);
    });

    testWidgets('탭 시 테마 설정 다이얼로그를 연다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const ThemePreferenceTile(
          title: '테마',
          icon: Icons.palette_outlined,
        ),
      );

      await tester.tap(find.text('테마'));
      await tester.pumpAndSettle();

      expect(find.text('테마 설정'), findsOneWidget);
      expect(find.byType(ThemeModeSelectionDialog), findsOneWidget);
    });
  });
}
