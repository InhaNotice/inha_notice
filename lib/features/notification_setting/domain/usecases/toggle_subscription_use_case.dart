/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/notification_setting/domain/failures/notification_setting_failure.dart';
import 'package:inha_notice/features/notification_setting/domain/repositories/notification_setting_repository.dart';

class ToggleSubscriptionUseCase {
  final NotificationSettingRepository repository;

  ToggleSubscriptionUseCase({required this.repository});

  Future<Either<NotificationSettingFailure, Unit>> call({
    required String prefKey,
    required String fcmTopic,
    required bool value,
    bool isSynchronizedWithMajor = false,
  }) async {
    return await repository.toggleSubscription(
      prefKey: prefKey,
      fcmTopic: fcmTopic,
      value: value,
      isSynchronizedWithMajor: isSynchronizedWithMajor,
    );
  }
}
