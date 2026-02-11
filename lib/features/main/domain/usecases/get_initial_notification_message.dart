/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-11
 */

import 'package:inha_notice/features/notification/domain/entities/notification_message_entity.dart';
import 'package:inha_notice/features/notification/domain/repositories/notification_repository.dart';

class GetInitialNotificationMessage {
  final NotificationRepository repository;

  GetInitialNotificationMessage({required this.repository});

  Future<NotificationMessageEntity> call() async {
    return await repository.getNotificationMessage();
  }
}
