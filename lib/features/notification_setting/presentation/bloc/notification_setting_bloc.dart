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
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/features/notice/domain/entities/college_type.dart';
import 'package:inha_notice/features/notice/domain/entities/graduate_school_type.dart';
import 'package:inha_notice/features/notice/domain/entities/major_type.dart';
import 'package:inha_notice/features/notification_setting/domain/usecases/get_subscription_status_use_case.dart';
import 'package:inha_notice/features/notification_setting/domain/usecases/toggle_subscription_use_case.dart';

import 'notification_setting_event.dart';
import 'notification_setting_state.dart';

class NotificationSettingBloc
    extends Bloc<NotificationSettingEvent, NotificationSettingState> {
  final GetSubscriptionStatusUseCase getSubscriptionStatusUseCase;
  final ToggleSubscriptionUseCase toggleSubscriptionUseCase;

  NotificationSettingBloc({
    required this.getSubscriptionStatusUseCase,
    required this.toggleSubscriptionUseCase,
  }) : super(NotificationSettingInitial()) {
    on<LoadAllSettingsEvent>(_onLoadAllSettings);
    on<ToggleTopicEvent>(_onToggleTopic);
  }

  /// 모든 알림 키에 대한 구독 상태를 로드
  Future<void> _onLoadAllSettings(LoadAllSettingsEvent event,
      Emitter<NotificationSettingState> emit) async {
    emit(NotificationSettingLoading());

    final Map<String, bool> subscriptions = {};

    final allKeys = _getAllNotificationKeys();

    for (final key in allKeys) {
      final result = await getSubscriptionStatusUseCase(prefKey: key);
      result.fold(
        (failure) {},
        (status) => subscriptions[key] = status,
      );
    }

    emit(NotificationSettingLoaded(subscriptions: subscriptions));
  }

  /// 토글 이벤트 처리: FCM 구독/해제 + SharedPrefs 저장
  Future<void> _onToggleTopic(
      ToggleTopicEvent event, Emitter<NotificationSettingState> emit) async {
    if (state is! NotificationSettingLoaded) return;
    final current = state as NotificationSettingLoaded;

    // 현재 토글 중인 키 표시
    emit(current.copyWith(togglingKey: event.prefKey));

    // major 동기화 여부 확인
    final isSynchronizedWithMajor = _isSynchronizedWithMajor(event.prefKey);

    final result = await toggleSubscriptionUseCase(
      prefKey: event.prefKey,
      fcmTopic: event.fcmTopic,
      value: event.value,
      isSynchronizedWithMajor: isSynchronizedWithMajor,
    );

    result.fold(
      (failure) {
        // 실패 시 롤백 (이전 상태 유지)
        emit(current.copyWith(togglingKey: null));
      },
      (_) {
        // 성공 시 Map 업데이트
        final updatedSubscriptions =
            Map<String, bool>.from(current.subscriptions);
        updatedSubscriptions[event.prefKey] = event.value;
        emit(NotificationSettingLoaded(subscriptions: updatedSubscriptions));
      },
    );
  }

  /// 현재 설정된 학과와 동기화되는 키인지 확인
  bool _isSynchronizedWithMajor(String prefKey) {
    return MajorType.majorValueList.contains(prefKey);
  }

  /// 모든 알림 관련 SharedPrefs 키를 반환
  List<String> _getAllNotificationKeys() {
    return [
      // 학사일정
      SharedPrefKeys.kUndergraduateScheduleD1Notification,
      SharedPrefKeys.kUndergraduateScheduleDDNotification,
      // 교육 및 행정 지원
      SharedPrefKeys.kAcademicNotification,
      SharedPrefKeys.kScholarship,
      SharedPrefKeys.kRecruitment,
      SharedPrefKeys.INTERNATIONAL,
      SharedPrefKeys.kLibrary,
      // 연구 및 학술 지원
      SharedPrefKeys.SWUNIV,
      SharedPrefKeys.INHAHUSS,
      // 단과대
      ...CollegeType.keys,
      // 대학원
      ...GraduateSchoolType.graduateSchoolKeyList,
      // 학과
      ...MajorType.majorValueList,
    ];
  }
}
