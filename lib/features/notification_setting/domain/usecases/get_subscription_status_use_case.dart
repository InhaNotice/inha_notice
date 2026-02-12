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

class GetSubscriptionStatusUseCase {
  final NotificationSettingRepository repository;

  GetSubscriptionStatusUseCase({required this.repository});

  Future<Either<NotificationSettingFailure, bool>> call(
      {required String prefKey}) async {
    return await repository.getSubscriptionStatus(prefKey);
  }
}
