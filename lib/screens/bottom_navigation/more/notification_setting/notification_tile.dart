/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/core/config/app_theme.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/presentation/widgets/themed_snack_bar_widget.dart';
import 'package:inha_notice/firebase/firebase_service.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/widgets/dialogs/blocking_dialog.dart';

/// **NotificationTile**
/// 이 클래스는 알림설정 페이지의 알림 온/오프의 동작을 정의합니다.
class NotificationTile extends StatefulWidget {
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
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool _isProcessing = false;
  bool _isNotificationOn = false;
  bool _isSynchronizedWithMajor = false;
  String? majorKey;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  /// **알림 토글의 설정값을 불러옴**
  Future<void> _loadNotificationPreference() async {
    setState(() {
      majorKey = SharedPrefsManager().getPreference(SharedPrefKeys.kMajorKey);
      // 현재 설정된 나의 학과인 경우, 나의 학과의 설정된 불 값으로 반영
      if (majorKey != null && widget.prefKey == majorKey) {
        _isSynchronizedWithMajor = true;
        _isNotificationOn = SharedPrefsManager()
            .getPreference(SharedPrefKeys.kMajorNotification);
      } else {
        _isNotificationOn = SharedPrefsManager().getPreference(widget.prefKey);
      }
    });
  }

  Future<void> _toggleNotification(bool value) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      BlockingDialog.show(context);
    });

    try {
      if (value) {
        await FirebaseService().subscribeToTopic(widget.fcmTopic);
      } else {
        await FirebaseService().unsubscribeFromTopic(widget.fcmTopic);
      }

      if (_isSynchronizedWithMajor) {
        await SharedPrefsManager()
            .setPreference(SharedPrefKeys.kMajorNotification, value);
      }
      await SharedPrefsManager().setPreference(widget.prefKey, value);

      setState(() {
        _isNotificationOn = value;
      });

      if (mounted) {
        ThemedSnackBarWidget.succeedSnackBar(
            context,
            value
                ? '${widget.title}의 알림이 활성화되었습니다.'
                : '${widget.title}의 알림이 비활성화되었습니다.');
      }
    } catch (e) {
      if (mounted) {
        ThemedSnackBarWidget.failSnackBar(context, '알림 설정 중 오류가 발생했습니다.');
      }
    } finally {
      if (mounted) {
        BlockingDialog.dismiss(context);
      }
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
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
                value: _isNotificationOn,
                onChanged: _toggleNotification,
                activeColor: Theme.of(context).primaryColorLight,
              ),
            ),
          ],
        ),
        // description은 선택
        if (widget.description.isNotEmpty)
          Text(
            softWrap: true,
            widget.description,
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
  }
}
