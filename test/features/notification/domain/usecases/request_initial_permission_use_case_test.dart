/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/notification/domain/entities/notification_message_entity.dart';
import 'package:inha_notice/features/notification/domain/repositories/notification_repository.dart';
import 'package:inha_notice/features/notification/domain/usecases/request_initial_permission_use_case.dart';

class _FakeNotificationRepository implements NotificationRepository {
  bool requested = false;

  @override
  Future<NotificationMessageEntity> getNotificationMessage() async {
    return const NotificationMessageEntity(id: null, link: null);
  }

  @override
  Future<void> requestPermission() async {
    requested = true;
  }
}

void main() {
  group('RequestInitialPermissionUseCase 유닛 테스트', () {
    test('플랫폼 조건에 따라 권한 요청 호출 여부가 달라진다', () async {
      final repository = _FakeNotificationRepository();
      final useCase = RequestInitialPermissionUseCase(repository: repository);

      await useCase();

      expect(repository.requested, Platform.isIOS);
    });
  });
}
