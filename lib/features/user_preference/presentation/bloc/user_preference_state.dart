/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:equatable/equatable.dart';
import 'package:inha_notice/features/user_preference/domain/entities/user_preference_entity.dart';

abstract class UserPreferenceState extends Equatable {
  const UserPreferenceState();

  @override
  List<Object?> get props => [];
}

class UserPreferenceInitial extends UserPreferenceState {}

class UserPreferenceLoading extends UserPreferenceState {}

class UserPreferenceLoaded extends UserPreferenceState {
  final UserPreferenceEntity preferences;

  const UserPreferenceLoaded({required this.preferences});

  @override
  List<Object?> get props => [preferences];
}

class UserPreferenceError extends UserPreferenceState {
  final String message;

  const UserPreferenceError({required this.message});

  @override
  List<Object?> get props => [message];
}
