/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/notification_setting/data/datasources/notification_setting_local_data_source.dart';
import 'package:inha_notice/features/notification_setting/data/datasources/notification_setting_remote_data_source.dart';
import 'package:inha_notice/features/notification_setting/data/repositories/notification_setting_repository_impl.dart';

class _FakeNotificationSettingLocalDataSource
    implements NotificationSettingLocalDataSource {
  bool status = false;
  Object? getError;
  Object? saveError;
  String? savedPrefKey;
  bool? savedValue;
  bool? savedSync;

  @override
  bool getSubscriptionStatus(String prefKey) {
    if (getError != null) {
      throw getError!;
    }
    return status;
  }

  @override
  Future<void> saveSubscriptionStatus(
      String prefKey, bool value, bool isSynchronizedWithMajor) async {
    if (saveError != null) {
      throw saveError!;
    }
    savedPrefKey = prefKey;
    savedValue = value;
    savedSync = isSynchronizedWithMajor;
  }
}

class _FakeNotificationSettingRemoteDataSource
    implements NotificationSettingRemoteDataSource {
  Object? subscribeError;
  Object? unsubscribeError;
  String? subscribedTopic;
  String? unsubscribedTopic;

  @override
  Future<void> subscribe(String fcmTopic) async {
    if (subscribeError != null) {
      throw subscribeError!;
    }
    subscribedTopic = fcmTopic;
  }

  @override
  Future<void> unsubscribe(String fcmTopic) async {
    if (unsubscribeError != null) {
      throw unsubscribeError!;
    }
    unsubscribedTopic = fcmTopic;
  }
}

void main() {
  group('NotificationSettingRepositoryImpl 유닛 테스트', () {
    test('getSubscriptionStatus 성공 시 Right를 반환한다', () async {
      final local = _FakeNotificationSettingLocalDataSource()..status = true;
      final remote = _FakeNotificationSettingRemoteDataSource();
      final repository = NotificationSettingRepositoryImpl(
        localDataSource: local,
        remoteDataSource: remote,
      );

      final result = await repository.getSubscriptionStatus('CSE');

      expect(result, const Right(true));
    });

    test('getSubscriptionStatus 실패 시 loadSetting Failure를 반환한다', () async {
      final local = _FakeNotificationSettingLocalDataSource()
        ..getError = Exception('read failed');
      final remote = _FakeNotificationSettingRemoteDataSource();
      final repository = NotificationSettingRepositoryImpl(
        localDataSource: local,
        remoteDataSource: remote,
      );

      final result = await repository.getSubscriptionStatus('CSE');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('read failed')),
        (_) => fail('Left 이어야 합니다.'),
      );
    });

    test('toggleSubscription(true) 성공 시 subscribe 후 local 저장한다', () async {
      final local = _FakeNotificationSettingLocalDataSource();
      final remote = _FakeNotificationSettingRemoteDataSource();
      final repository = NotificationSettingRepositoryImpl(
        localDataSource: local,
        remoteDataSource: remote,
      );

      final result = await repository.toggleSubscription(
        prefKey: 'CSE',
        fcmTopic: 'major_CSE',
        value: true,
        isSynchronizedWithMajor: true,
      );

      expect(remote.subscribedTopic, 'major_CSE');
      expect(local.savedPrefKey, 'CSE');
      expect(local.savedValue, isTrue);
      expect(local.savedSync, isTrue);
      expect(result, const Right(unit));
    });

    test('toggleSubscription(false) 원격 실패 시 toggleSetting Failure를 반환한다',
        () async {
      final local = _FakeNotificationSettingLocalDataSource();
      final remote = _FakeNotificationSettingRemoteDataSource()
        ..unsubscribeError = Exception('fcm failed');
      final repository = NotificationSettingRepositoryImpl(
        localDataSource: local,
        remoteDataSource: remote,
      );

      final result = await repository.toggleSubscription(
        prefKey: 'CSE',
        fcmTopic: 'major_CSE',
        value: false,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('fcm failed')),
        (_) => fail('Left 이어야 합니다.'),
      );
      expect(local.savedPrefKey, isNull);
    });
  });
}
