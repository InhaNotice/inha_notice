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
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/presentation/utils/app_snack_bar.dart';
import 'package:inha_notice/core/presentation/utils/blocking_dialog.dart';
import 'package:inha_notice/features/notification_setting/presentation/bloc/notification_setting_bloc.dart';
import 'package:inha_notice/features/notification_setting/presentation/bloc/notification_setting_event.dart';
import 'package:inha_notice/features/notification_setting/presentation/bloc/notification_setting_state.dart';

/// **NotificationTile**
/// 이 클래스는 알림설정 페이지의 알림 온/오프의 동작을 정의합니다.
class NotificationTile extends StatelessWidget {
  final String title;
  final String description;
  final String prefKey;
  final String fcmTopic;

  const NotificationTile({
    super.key,
    required this.title,
    this.description = '',
    required this.prefKey,
    required this.fcmTopic,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationSettingBloc, NotificationSettingState>(
      listenWhen: (previous, current) {
        if (previous is NotificationSettingLoaded &&
            current is NotificationSettingLoaded) {
          final wasToggling = previous.togglingKey == prefKey;
          final isNotToggling = current.togglingKey != prefKey;
          // 토글이 완료된 시점
          if (wasToggling && isNotToggling) return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is NotificationSettingLoaded) {
          BlockingDialog.dismiss(context);
          final isOn = state.subscriptions[prefKey] ?? false;
          AppSnackBar.success(
            context,
            isOn ? '$title의 알림이 활성화되었습니다.' : '$title의 알림이 비활성화되었습니다.',
          );
        }
      },
      buildWhen: (previous, current) {
        if (current is! NotificationSettingLoaded) return true;
        if (previous is! NotificationSettingLoaded) return true;
        return previous.subscriptions[prefKey] !=
                current.subscriptions[prefKey] ||
            previous.togglingKey != current.togglingKey;
      },
      builder: (context, state) {
        final isOn = _getIsOn(state);
        final isToggling = _getIsToggling(state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppFont.pretendard.family,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Theme.of(context).defaultThemedTextColor,
                  ),
                ),
                Transform.scale(
                  scale: 0.9,
                  child: Switch.adaptive(
                    value: isOn,
                    onChanged: isToggling
                        ? null
                        : (value) {
                            BlockingDialog.show(context);
                            context
                                .read<NotificationSettingBloc>()
                                .add(ToggleTopicEvent(
                                  prefKey: prefKey,
                                  fcmTopic: fcmTopic,
                                  value: value,
                                ));
                          },
                    activeColor: Theme.of(context).primaryColorLight,
                  ),
                ),
              ],
            ),
            if (description.isNotEmpty)
              Text(
                softWrap: true,
                description,
                style: TextStyle(
                  fontFamily: AppFont.pretendard.family,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).textTheme.bodyMedium?.color ??
                      Theme.of(context).defaultThemedTextColor,
                ),
              ),
          ],
        );
      },
    );
  }

  bool _getIsOn(NotificationSettingState state) {
    if (state is NotificationSettingLoaded) {
      return state.subscriptions[prefKey] ?? false;
    }
    return false;
  }

  bool _getIsToggling(NotificationSettingState state) {
    if (state is NotificationSettingLoaded) {
      return state.togglingKey == prefKey;
    }
    return false;
  }
}
