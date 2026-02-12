/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/presentation/widgets/blue_loading_indicator_widget.dart';
import 'package:inha_notice/core/presentation/widgets/common_app_bar_widget.dart';
import 'package:inha_notice/features/notice/domain/entities/major_type.dart';
import 'package:inha_notice/features/notification_setting/domain/entities/notification_major_item.dart';
import 'package:inha_notice/features/notification_setting/presentation/bloc/notification_setting_bloc.dart';
import 'package:inha_notice/features/notification_setting/presentation/bloc/notification_setting_event.dart';
import 'package:inha_notice/features/notification_setting/presentation/bloc/notification_setting_state.dart';
import 'package:inha_notice/features/notification_setting/presentation/widgets/categories/college_notification_category.dart';
import 'package:inha_notice/features/notification_setting/presentation/widgets/categories/education_notification_category.dart';
import 'package:inha_notice/features/notification_setting/presentation/widgets/categories/graduate_school_notification_category.dart';
import 'package:inha_notice/features/notification_setting/presentation/widgets/categories/major_notification_category.dart';
import 'package:inha_notice/features/notification_setting/presentation/widgets/categories/research_notification_category.dart';
import 'package:inha_notice/features/notification_setting/presentation/widgets/categories/undergraduate_schedule_notification_category.dart';
import 'package:inha_notice/injection_container.dart' as di;

/// **NotificationSettingPage**
/// 이 클래스는 알림 설정 페이지를 정의하는 클래스입니다.
class NotificationSettingPage extends StatelessWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          di.sl<NotificationSettingBloc>()..add(LoadAllSettingsEvent()),
      child: Scaffold(
        appBar: const CommonAppBarWidget(
            title: '알림 설정', titleSize: 20, isCenter: true),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<NotificationSettingBloc, NotificationSettingState>(
          builder: (context, state) {
            if (state is NotificationSettingLoading ||
                state is NotificationSettingInitial) {
              return const Center(child: BlueLoadingIndicatorWidget());
            }
            if (state is NotificationSettingError) {
              return Center(child: Text(state.message));
            }
            if (state is NotificationSettingLoaded) {
              return _buildBody();
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UndergraduateScheduleNotificationCategory(),
          EducationNotificationCategory(),
          ResearchNotificationCategory(),
          CollegeNotificationCategory(),
          GraduateSchoolNotificationCategory(),
          ...MajorType.majorGroups.entries.map(
            (college) {
              return MajorNotificationCategory(
                  title: college.key,
                  items: college.value.entries.map((major) {
                    return NotificationMajorItem(
                      title: major.key,
                      key: major.value,
                      topic: major.value,
                    );
                  }).toList());
            },
          ),
        ],
      ),
    );
  }
}
