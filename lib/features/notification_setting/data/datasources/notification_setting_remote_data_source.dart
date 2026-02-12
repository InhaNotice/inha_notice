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

abstract class NotificationSettingRemoteDataSource {
  Future<void> subscribe(String fcmTopic);

  Future<void> unsubscribe(String fcmTopic);
}

class NotificationSettingRemoteDataSourceImpl
    implements NotificationSettingRemoteDataSource {
  final FirebaseRemoteDataSource firebaseDataSource;

  NotificationSettingRemoteDataSourceImpl({required this.firebaseDataSource});

  @override
  Future<void> subscribe(String fcmTopic) async {
    await firebaseDataSource.subscribeToTopic(fcmTopic);
  }

  @override
  Future<void> unsubscribe(String fcmTopic) async {
    await firebaseDataSource.unsubscribeFromTopic(fcmTopic);
  }
}
