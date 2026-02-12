/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:equatable/equatable.dart';

abstract class NotificationSettingState extends Equatable {
  const NotificationSettingState();

  @override
  List<Object?> get props => [];
}

class NotificationSettingInitial extends NotificationSettingState {}

class NotificationSettingLoading extends NotificationSettingState {}

class NotificationSettingLoaded extends NotificationSettingState {
  final Map<String, bool> subscriptions;
  final String? togglingKey;

  const NotificationSettingLoaded({
    required this.subscriptions,
    this.togglingKey,
  });

  NotificationSettingLoaded copyWith({
    Map<String, bool>? subscriptions,
    String? togglingKey,
  }) {
    return NotificationSettingLoaded(
      subscriptions: subscriptions ?? this.subscriptions,
      togglingKey: togglingKey,
    );
  }

  @override
  List<Object?> get props => [subscriptions, togglingKey];
}

class NotificationSettingError extends NotificationSettingState {
  final String message;

  const NotificationSettingError({required this.message});

  @override
  List<Object?> get props => [message];
}
