import 'package:flutter/material.dart';

import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() => _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          '알림 설정',
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color ??
              Theme.of(context).defaultColor,
          ),
        ),
      ),
    );
  }
}