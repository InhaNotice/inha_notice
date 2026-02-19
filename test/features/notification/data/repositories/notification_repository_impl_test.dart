/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/notification/data/datasources/firebase_remote_data_source.dart';
import 'package:inha_notice/features/notification/data/models/notification_message_model.dart';
import 'package:inha_notice/features/notification/data/repositories/notification_repository_impl.dart';

class _FakeFirebaseRemoteDataSource implements FirebaseRemoteDataSource {
  bool requested = false;
  NoticeNotificationModel result =
      const NoticeNotificationModel(id: '1', link: '/notice/1');

  @override
  Future<NoticeNotificationModel> getNotificationMessage() async {
    return result;
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<void> requestPermission() async {
    requested = true;
  }

  @override
  Future<void> subscribeToTopic(String topic) async {}

  @override
  Future<void> unsubscribeFromTopic(String topic) async {}
}

void main() {
  group('NotificationRepositoryImpl 유닛 테스트', () {
    test('requestPermission은 remoteDataSource에 위임한다', () async {
      final remote = _FakeFirebaseRemoteDataSource();
      final repository = NotificationRepositoryImpl(remoteDataSource: remote);

      await repository.requestPermission();

      expect(remote.requested, isTrue);
    });

    test('getNotificationMessage는 remoteDataSource 결과를 반환한다', () async {
      final remote = _FakeFirebaseRemoteDataSource()
        ..result = const NoticeNotificationModel(id: '99', link: '/n/99');
      final repository = NotificationRepositoryImpl(remoteDataSource: remote);

      final result = await repository.getNotificationMessage();

      expect(result.id, '99');
      expect(result.link, '/n/99');
    });
  });
}
