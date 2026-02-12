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

abstract class NotificationSettingEvent extends Equatable {
  const NotificationSettingEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllSettingsEvent extends NotificationSettingEvent {}

class ToggleTopicEvent extends NotificationSettingEvent {
  final String prefKey;
  final String fcmTopic;
  final bool value;

  const ToggleTopicEvent({
    required this.prefKey,
    required this.fcmTopic,
    required this.value,
  });

  @override
  List<Object?> get props => [prefKey, fcmTopic, value];
}
