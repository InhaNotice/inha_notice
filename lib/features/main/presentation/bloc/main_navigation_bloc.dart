/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/main/domain/usecases/get_initial_notification_message.dart';
import 'package:inha_notice/features/main/presentation/bloc/main_navigation_event.dart';
import 'package:inha_notice/features/main/presentation/bloc/main_navigation_state.dart';
import 'package:inha_notice/features/notice/data/datasources/read_notice_local_data_source.dart';
import 'package:inha_notice/features/notification/domain/entities/notification_message_entity.dart';

class MainNavigationBloc
    extends Bloc<MainNavigationEvent, MainNavigationState> {
  final GetInitialNotificationMessage getInitialNotificationMessage;

  MainNavigationBloc({
    required this.getInitialNotificationMessage,
  }) : super(const MainNavigationState()) {
    on<CheckNoticeNotificationEvent>(_onCheckNoticeNotification);
    on<ChangeMainTabEvent>(_onChangeMainTab);
  }

  Future<void> _onCheckNoticeNotification(CheckNoticeNotificationEvent event,
      Emitter<MainNavigationState> emit) async {
    final NotificationMessageEntity notificationEntity =
        await getInitialNotificationMessage();

    final String? noticeId = notificationEntity.id;
    final String? noticeLink = notificationEntity.link;

    if (noticeId != null) {
      ReadNoticeLocalDataSource.addReadNotice(noticeId);
    }

    if (noticeLink != null) {
      emit(state.copyWith(initialUrl: noticeLink));
    }
  }

  Future<void> _onChangeMainTab(
      ChangeMainTabEvent event, Emitter<MainNavigationState> emit) async {
    emit(state.copyWith(tabIndex: event.index));
  }
}
