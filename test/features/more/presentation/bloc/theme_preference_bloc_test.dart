/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/config/app_theme_type.dart';
import 'package:inha_notice/features/more/domain/failures/theme_preference_failure.dart';
import 'package:inha_notice/features/more/domain/repositories/theme_preference_repository.dart';
import 'package:inha_notice/features/more/domain/usecases/get_theme_preference_use_case.dart';
import 'package:inha_notice/features/more/domain/usecases/set_theme_preference_use_case.dart';
import 'package:inha_notice/features/more/presentation/bloc/theme_preference_bloc.dart';
import 'package:inha_notice/features/more/presentation/bloc/theme_preference_event.dart';
import 'package:inha_notice/features/more/presentation/bloc/theme_preference_state.dart';
import 'package:inha_notice/main.dart';

class _FakeThemePreferenceRepository implements ThemePreferenceRepository {
  Either<ThemePreferenceFailure, ThemeMode> getResult =
      const Right(ThemeMode.system);
  Either<ThemePreferenceFailure, ThemeMode> setResult =
      const Right(ThemeMode.system);

  @override
  Either<ThemePreferenceFailure, ThemeMode> getThemeMode() {
    return getResult;
  }

  @override
  Future<Either<ThemePreferenceFailure, ThemeMode>> setThemeMode(
      ThemeMode themeMode) async {
    return setResult;
  }
}

Future<void> _flushEvents([int times = 20]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('ThemePreferenceBloc 유닛 테스트', () {
    late _FakeThemePreferenceRepository repository;
    late ThemePreferenceBloc bloc;
    late ThemeMode originalThemeMode;

    setUp(() {
      originalThemeMode = themeModeNotifier.value;
      repository = _FakeThemePreferenceRepository();
      bloc = ThemePreferenceBloc(
        getThemePreferenceUseCase:
            GetThemePreferenceUseCase(repository: repository),
        setThemePreferenceUseCase:
            SetThemePreferenceUseCase(repository: repository),
      );
    });

    tearDown(() async {
      themeModeNotifier.value = originalThemeMode;
      await bloc.close();
    });

    test('LoadThemePreferenceEvent 성공 시 loaded 상태가 된다', () async {
      repository.getResult = const Right(ThemeMode.dark);

      bloc.add(LoadThemePreferenceEvent());
      await _flushEvents();

      expect(
        bloc.state,
        const ThemePreferenceLoaded(
          themeMode: ThemeMode.dark,
          description: '다크',
        ),
      );
    });

    test('LoadThemePreferenceEvent 실패 시 system 기본값 loaded 상태가 된다', () async {
      repository.getResult = const Left(ThemePreferenceFailure.storage());

      bloc.add(LoadThemePreferenceEvent());
      await _flushEvents();

      expect(
        bloc.state,
        ThemePreferenceLoaded(
          themeMode: ThemeMode.system,
          description: AppThemeType.system.text,
        ),
      );
    });

    test('ChangeThemePreferenceEvent 성공 시 notifier와 loaded 상태가 갱신된다', () async {
      repository.setResult = const Right(ThemeMode.light);

      bloc.add(const ChangeThemePreferenceEvent(themeMode: ThemeMode.light));
      await _flushEvents();

      expect(themeModeNotifier.value, ThemeMode.light);
      expect(
        bloc.state,
        const ThemePreferenceLoaded(
          themeMode: ThemeMode.light,
          description: '화이트',
        ),
      );
    });

    test('ChangeThemePreferenceEvent 실패 시 error 상태가 된다', () async {
      repository.setResult = const Left(ThemePreferenceFailure.storage());

      bloc.add(const ChangeThemePreferenceEvent(themeMode: ThemeMode.dark));
      await _flushEvents();

      expect(bloc.state, const ThemePreferenceError(message: '테마 설정 저장 오류'));
    });
  });
}
