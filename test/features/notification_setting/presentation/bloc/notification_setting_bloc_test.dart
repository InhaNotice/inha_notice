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
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/features/notification_setting/domain/failures/notification_setting_failure.dart';
import 'package:inha_notice/features/notification_setting/domain/repositories/notification_setting_repository.dart';
import 'package:inha_notice/features/notification_setting/domain/usecases/get_subscription_status_use_case.dart';
import 'package:inha_notice/features/notification_setting/domain/usecases/toggle_subscription_use_case.dart';
import 'package:inha_notice/features/notification_setting/presentation/bloc/notification_setting_bloc.dart';
import 'package:inha_notice/features/notification_setting/presentation/bloc/notification_setting_event.dart';
import 'package:inha_notice/features/notification_setting/presentation/bloc/notification_setting_state.dart';

class _FakeNotificationSettingRepository
    implements NotificationSettingRepository {
  final Map<String, Either<NotificationSettingFailure, bool>> statusByKey = {};
  Either<NotificationSettingFailure, Unit> toggleResult = const Right(unit);

  String? lastTogglePrefKey;
  String? lastToggleTopic;
  bool? lastToggleValue;
  bool? lastToggleSync;

  @override
  Future<Either<NotificationSettingFailure, bool>> getSubscriptionStatus(
      String prefKey) async {
    return statusByKey[prefKey] ?? const Right(false);
  }

  @override
  Future<Either<NotificationSettingFailure, Unit>> toggleSubscription({
    required String prefKey,
    required String fcmTopic,
    required bool value,
    bool isSynchronizedWithMajor = false,
  }) async {
    lastTogglePrefKey = prefKey;
    lastToggleTopic = fcmTopic;
    lastToggleValue = value;
    lastToggleSync = isSynchronizedWithMajor;
    return toggleResult;
  }
}

Future<void> _flushEvents([int times = 40]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('NotificationSettingBloc 유닛 테스트', () {
    late _FakeNotificationSettingRepository repository;
    late NotificationSettingBloc bloc;

    setUp(() {
      repository = _FakeNotificationSettingRepository()
        ..statusByKey[SharedPrefKeys.kAcademicNotification] = const Right(true)
        ..statusByKey['CSE'] = const Right(false);
      bloc = NotificationSettingBloc(
        getSubscriptionStatusUseCase:
            GetSubscriptionStatusUseCase(repository: repository),
        toggleSubscriptionUseCase:
            ToggleSubscriptionUseCase(repository: repository),
      );
    });

    tearDown(() async {
      await bloc.close();
    });

    test('LoadAllSettingsEvent 성공 시 loaded 상태에 구독값이 반영된다', () async {
      bloc.add(LoadAllSettingsEvent());
      await _flushEvents();

      expect(bloc.state, isA<NotificationSettingLoaded>());
      final loaded = bloc.state as NotificationSettingLoaded;
      expect(
          loaded.subscriptions[SharedPrefKeys.kAcademicNotification], isTrue);
      expect(loaded.subscriptions.containsKey('CSE'), isTrue);
    });

    test('LoadAllSettingsEvent에서 일부 키 실패는 무시하고 loaded 상태를 반환한다', () async {
      repository.statusByKey[SharedPrefKeys.kScholarship] =
          const Left(NotificationSettingFailure.loadSetting('오류'));

      bloc.add(LoadAllSettingsEvent());
      await _flushEvents();

      expect(bloc.state, isA<NotificationSettingLoaded>());
      final loaded = bloc.state as NotificationSettingLoaded;
      expect(loaded.subscriptions.containsKey(SharedPrefKeys.kScholarship),
          isFalse);
    });

    test('ToggleTopicEvent 성공 시 해당 키 값이 갱신된다', () async {
      bloc.add(LoadAllSettingsEvent());
      await _flushEvents();

      bloc.add(const ToggleTopicEvent(
        prefKey: SharedPrefKeys.kAcademicNotification,
        fcmTopic: 'academic-notification',
        value: false,
      ));
      await _flushEvents();

      final loaded = bloc.state as NotificationSettingLoaded;
      expect(
          loaded.subscriptions[SharedPrefKeys.kAcademicNotification], isFalse);
      expect(loaded.togglingKey, isNull);
    });

    test('ToggleTopicEvent 실패 시 기존 상태를 유지한다', () async {
      bloc.add(LoadAllSettingsEvent());
      await _flushEvents();
      final before = bloc.state as NotificationSettingLoaded;

      repository.toggleResult =
          const Left(NotificationSettingFailure.toggleSetting('토글 실패'));
      bloc.add(const ToggleTopicEvent(
        prefKey: SharedPrefKeys.kAcademicNotification,
        fcmTopic: 'academic-notification',
        value: false,
      ));
      await _flushEvents();

      final loaded = bloc.state as NotificationSettingLoaded;
      expect(loaded.subscriptions, before.subscriptions);
      expect(loaded.togglingKey, isNull);
    });

    test('학과 키 토글 시 isSynchronizedWithMajor=true로 전달된다', () async {
      bloc.add(LoadAllSettingsEvent());
      await _flushEvents();

      bloc.add(const ToggleTopicEvent(
        prefKey: 'CSE',
        fcmTopic: 'major_CSE',
        value: true,
      ));
      await _flushEvents();

      expect(repository.lastTogglePrefKey, 'CSE');
      expect(repository.lastToggleSync, isTrue);
    });
  });
}
