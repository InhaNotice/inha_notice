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
import 'package:inha_notice/features/notification_setting/domain/failures/notification_setting_failure.dart';
import 'package:inha_notice/features/notification_setting/domain/repositories/notification_setting_repository.dart';
import 'package:inha_notice/features/notification_setting/domain/usecases/get_subscription_status_use_case.dart';
import 'package:inha_notice/features/notification_setting/domain/usecases/toggle_subscription_use_case.dart';

class _FakeNotificationSettingRepository
    implements NotificationSettingRepository {
  Either<NotificationSettingFailure, bool> getResult = const Right(false);
  Either<NotificationSettingFailure, Unit> toggleResult = const Right(unit);

  String? lastPrefKey;
  String? lastFcmTopic;
  bool? lastValue;
  bool? lastIsSynchronizedWithMajor;

  @override
  Future<Either<NotificationSettingFailure, bool>> getSubscriptionStatus(
      String prefKey) async {
    lastPrefKey = prefKey;
    return getResult;
  }

  @override
  Future<Either<NotificationSettingFailure, Unit>> toggleSubscription({
    required String prefKey,
    required String fcmTopic,
    required bool value,
    bool isSynchronizedWithMajor = false,
  }) async {
    lastPrefKey = prefKey;
    lastFcmTopic = fcmTopic;
    lastValue = value;
    lastIsSynchronizedWithMajor = isSynchronizedWithMajor;
    return toggleResult;
  }
}

void main() {
  group('NotificationSetting UseCase 유닛 테스트', () {
    test('GetSubscriptionStatusUseCase는 prefKey를 전달한다', () async {
      final repository = _FakeNotificationSettingRepository()
        ..getResult = const Right(true);
      final useCase = GetSubscriptionStatusUseCase(repository: repository);

      final result = await useCase(prefKey: 'CSE');

      expect(repository.lastPrefKey, 'CSE');
      expect(result, const Right(true));
    });

    test('ToggleSubscriptionUseCase는 토글 파라미터를 전달한다', () async {
      final repository = _FakeNotificationSettingRepository();
      final useCase = ToggleSubscriptionUseCase(repository: repository);

      final result = await useCase(
        prefKey: 'CSE',
        fcmTopic: 'major_CSE',
        value: true,
        isSynchronizedWithMajor: true,
      );

      expect(repository.lastPrefKey, 'CSE');
      expect(repository.lastFcmTopic, 'major_CSE');
      expect(repository.lastValue, isTrue);
      expect(repository.lastIsSynchronizedWithMajor, isTrue);
      expect(result, const Right(unit));
    });
  });
}
