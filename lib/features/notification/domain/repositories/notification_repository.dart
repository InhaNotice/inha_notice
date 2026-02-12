/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:inha_notice/features/notification/domain/entities/notification_message_entity.dart';

abstract class NotificationRepository {
  Future<void> requestPermission();
  Future<NotificationMessageEntity> getNotificationMessage();
}
