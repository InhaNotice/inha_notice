/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-20
 */
import 'package:flutter/material.dart';
import 'package:inha_notice/firebase/firebase_service.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/widgets/dialogs/blocking_dialog.dart';
import 'package:inha_notice/widgets/themed_widgets/themed_snack_bar.dart';

/// **NotificationTile**
/// 이 클래스는 알림설정 페이지의 알림 온/오프의 동작을 정의합니다.
class NotificationTile extends StatefulWidget {
  final String title;
  final String description;
  final String topic;
  final bool Function() getPreference;
  final Future<void> Function(bool) setPreference;

  const NotificationTile(
      {super.key,
      required this.title,
      required this.description,
      required this.topic,
      required this.getPreference,
      required this.setPreference});

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool _isProcessing = false;
  bool _isNotificationOn = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    setState(() {
      _isNotificationOn = widget.getPreference();
    });
  }

  Future<void> _toggleNotification(bool value) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      BlockingDialog.show(context);
    });

    try {
      // title이 학과일 경우에만 실행
      final majorKey = SharedPrefsManager().getMajorKey();

      if (widget.topic == 'major-notification' && majorKey == null) {
        if (mounted) {
          BlockingDialog.dismiss(context);
          ThemedSnackBar.succeedSnackBar(context, '학과를 먼저 설정해주세요!');
        }
        return;
      }

      final firebaseService = FirebaseService();

      if (value) {
        await (widget.topic == 'major-notification'
            ? firebaseService.updateMajorSubscription()
            : firebaseService.subscribeToTopic(widget.topic));
      } else {
        await (widget.topic == 'major-notification'
            ? firebaseService.unsubscribeFromTopic(majorKey!)
            : firebaseService.unsubscribeFromTopic(widget.topic));
      }

      await widget.setPreference(value);

      setState(() {
        _isNotificationOn = value;
      });

      if (mounted) {
        ThemedSnackBar.succeedSnackBar(
            context,
            value
                ? '${widget.title}의 알림이 활성화되었습니다.'
                : '${widget.title}의 알림이 비활성화되었습니다.');
      }
    } catch (e) {
      if (mounted) {
        ThemedSnackBar.succeedSnackBar(context, '알림 설정 중 오류가 발생했습니다.');
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
                fontFamily: Font.kDefaultFont,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.bodyMedium?.color ??
                    Theme.of(context).defaultColor,
              ),
            ),
            Switch(
              value: _isNotificationOn,
              onChanged: _toggleNotification,
              activeColor: Theme.of(context).primaryColorLight,
            ),
          ],
        ),
        Text(
          widget.description,
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
                Theme.of(context).defaultColor,
          ),
        ),
      ],
    );
  }
}
