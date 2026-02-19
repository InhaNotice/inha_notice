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
import 'package:inha_notice/features/notification_setting/presentation/pages/notification_setting_page.dart';
import 'package:inha_notice/injection_container.dart' as di;

import '../../../support/widget_test_pump_app.dart';

class _FakeNotificationSettingRepository
    implements NotificationSettingRepository {
  final Map<String, bool> subscriptions = {};
  Either<NotificationSettingFailure, Unit> toggleResult = const Right(unit);

  @override
  Future<Either<NotificationSettingFailure, bool>> getSubscriptionStatus(
      String prefKey) async {
    return Right(subscriptions[prefKey] ?? false);
  }

  @override
  Future<Either<NotificationSettingFailure, Unit>> toggleSubscription({
    required String prefKey,
    required String fcmTopic,
    required bool value,
    bool isSynchronizedWithMajor = false,
  }) async {
    subscriptions[prefKey] = value;
    return toggleResult;
  }
}

void main() {
  group('NotificationSettingPage 위젯 테스트', () {
    late _FakeNotificationSettingRepository repository;
    late NotificationSettingBloc createdBloc;

    setUp(() async {
      await di.sl.reset();
      repository = _FakeNotificationSettingRepository()
        ..subscriptions[SharedPrefKeys.kAcademicNotification] = false;

      di.sl.registerFactory<NotificationSettingBloc>(() {
        createdBloc = NotificationSettingBloc(
          getSubscriptionStatusUseCase:
              GetSubscriptionStatusUseCase(repository: repository),
          toggleSubscriptionUseCase:
              ToggleSubscriptionUseCase(repository: repository),
        );
        return createdBloc;
      });
    });

    tearDown(() async {
      await di.sl.reset();
    });

    testWidgets('주요 카테고리와 알림 타일을 렌더링한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const NotificationSettingPage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('알림 설정'), findsOneWidget);
      expect(find.text('학사일정'), findsOneWidget);
      expect(find.text('교육 및 행정 지원'), findsOneWidget);
      expect(find.text('학사'), findsOneWidget);
    });

    testWidgets('토글 이벤트 성공 시 활성화 안내 스낵바를 노출한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const NotificationSettingPage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      createdBloc.add(const ToggleTopicEvent(
        prefKey: SharedPrefKeys.kAcademicNotification,
        fcmTopic: SharedPrefKeys.kAllNotices,
        value: true,
      ));
      await tester.pumpAndSettle();

      expect(
          repository.subscriptions[SharedPrefKeys.kAcademicNotification], true);
      expect(find.text('학사의 알림이 활성화되었습니다.'), findsOneWidget);
    });
  });
}
