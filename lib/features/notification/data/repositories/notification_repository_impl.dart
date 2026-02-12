/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:inha_notice/features/notification/data/datasources/firebase_remote_data_source.dart';
import 'package:inha_notice/features/notification/domain/entities/notification_message_entity.dart';
import 'package:inha_notice/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> requestPermission() async {
    return await remoteDataSource.requestPermission();
  }

  @override
  Future<NotificationMessageEntity> getNotificationMessage() async {
    return await remoteDataSource.getNotificationMessage();
  }
}
