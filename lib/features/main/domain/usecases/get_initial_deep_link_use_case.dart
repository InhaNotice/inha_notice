/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-09
 */

import 'package:inha_notice/features/notification/domain/repositories/notification_repository.dart';

class GetInitialDeepLinkUseCase {
  final NotificationRepository repository;

  GetInitialDeepLinkUseCase({required this.repository});

  Future<String?> call() async {
    return await repository.getInitialMessageLink();
  }
}
