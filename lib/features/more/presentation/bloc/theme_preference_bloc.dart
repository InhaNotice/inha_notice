/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/config/app_theme_type.dart';
import 'package:inha_notice/features/more/domain/usecases/get_theme_preference_use_case.dart';
import 'package:inha_notice/features/more/domain/usecases/set_theme_preference_use_case.dart';
import 'package:inha_notice/features/more/presentation/bloc/theme_preference_event.dart';
import 'package:inha_notice/features/more/presentation/bloc/theme_preference_state.dart';
import 'package:inha_notice/main.dart';

class ThemePreferenceBloc
    extends Bloc<ThemePreferenceEvent, ThemePreferenceState> {
  final GetThemePreferenceUseCase getThemePreferenceUseCase;
  final SetThemePreferenceUseCase setThemePreferenceUseCase;

  ThemePreferenceBloc({
    required this.getThemePreferenceUseCase,
    required this.setThemePreferenceUseCase,
  }) : super(ThemePreferenceInitial()) {
    on<LoadThemePreferenceEvent>(_onLoadThemePreference);
    on<ChangeThemePreferenceEvent>(_onChangeThemePreference);
  }

  void _onLoadThemePreference(
    LoadThemePreferenceEvent event,
    Emitter<ThemePreferenceState> emit,
  ) {
    final result = getThemePreferenceUseCase();

    result.fold(
      (failure) => emit(ThemePreferenceLoaded(
        themeMode: ThemeMode.system,
        description: AppThemeType.system.text,
      )),
      (themeMode) => emit(ThemePreferenceLoaded(
        themeMode: themeMode,
        description: _themeModeToDescription(themeMode),
      )),
    );
  }

  Future<void> _onChangeThemePreference(
    ChangeThemePreferenceEvent event,
    Emitter<ThemePreferenceState> emit,
  ) async {
    final result = await setThemePreferenceUseCase(event.themeMode);

    result.fold(
      (failure) => emit(ThemePreferenceError(message: failure.message)),
      (themeMode) {
        // 글로벌 themeModeNotifier 업데이트
        themeModeNotifier.value = themeMode;

        emit(ThemePreferenceLoaded(
          themeMode: themeMode,
          description: _themeModeToDescription(themeMode),
        ));
      },
    );
  }

  String _themeModeToDescription(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return AppThemeType.light.text;
      case ThemeMode.dark:
        return AppThemeType.dark.text;
      case ThemeMode.system:
        return AppThemeType.system.text;
    }
  }
}
