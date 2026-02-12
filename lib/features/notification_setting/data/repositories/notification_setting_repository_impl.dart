/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/notification_setting/data/datasources/notification_setting_local_data_source.dart';
import 'package:inha_notice/features/notification_setting/data/datasources/notification_setting_remote_data_source.dart';
import 'package:inha_notice/features/notification_setting/domain/failures/notification_setting_failure.dart';
import 'package:inha_notice/features/notification_setting/domain/repositories/notification_setting_repository.dart';

class NotificationSettingRepositoryImpl
    implements NotificationSettingRepository {
  final NotificationSettingLocalDataSource localDataSource;
  final NotificationSettingRemoteDataSource remoteDataSource;

  NotificationSettingRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<NotificationSettingFailure, bool>> getSubscriptionStatus(
      String prefKey) async {
    try {
      final status = localDataSource.getSubscriptionStatus(prefKey);
      return Right(status);
    } catch (e) {
      return Left(NotificationSettingFailure.loadSetting(e.toString()));
    }
  }

  @override
  Future<Either<NotificationSettingFailure, Unit>> toggleSubscription({
    required String prefKey,
    required String fcmTopic,
    required bool value,
    bool isSynchronizedWithMajor = false,
  }) async {
    try {
      if (value) {
        await remoteDataSource.subscribe(fcmTopic);
      } else {
        await remoteDataSource.unsubscribe(fcmTopic);
      }

      await localDataSource.saveSubscriptionStatus(
          prefKey, value, isSynchronizedWithMajor);

      return const Right(unit);
    } catch (e) {
      return Left(NotificationSettingFailure.toggleSetting(e.toString()));
    }
  }
}
