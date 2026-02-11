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

abstract class ThemePreferenceState extends Equatable {
  const ThemePreferenceState();

  @override
  List<Object?> get props => [];
}

class ThemePreferenceInitial extends ThemePreferenceState {}

class ThemePreferenceLoaded extends ThemePreferenceState {
  final ThemeMode themeMode;
  final String description;

  const ThemePreferenceLoaded({
    required this.themeMode,
    required this.description,
  });

  @override
  List<Object?> get props => [themeMode, description];
}

class ThemePreferenceError extends ThemePreferenceState {
  final String message;

  const ThemePreferenceError({required this.message});

  @override
  List<Object?> get props => [message];
}
