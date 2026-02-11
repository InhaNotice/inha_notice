/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-11
 */

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemePreferenceEvent extends Equatable {
  const ThemePreferenceEvent();

  @override
  List<Object?> get props => [];
}

class LoadThemePreferenceEvent extends ThemePreferenceEvent {}

class ChangeThemePreferenceEvent extends ThemePreferenceEvent {
  final ThemeMode themeMode;

  const ChangeThemePreferenceEvent({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];
}
