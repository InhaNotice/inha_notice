// lib/services/background.dart

import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BackgroundService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initializeService() async {
    final service = FlutterBackgroundService();

    // iOS 알림 초기화
    const DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const InitializationSettings initializationSettings =
    InitializationSettings(iOS: iosInitializationSettings);
    await _notificationsPlugin.initialize(initializationSettings);

    // 서비스 구성
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: (_) {},
        autoStart: false,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        autoStart: false,
        onBackground: onIosBackground,
      ),
    );

    service.startService();
  }

  static bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    print('iOS 백그라운드 작업 실행 중...');
    return true;
  }

  static void onStart(ServiceInstance service) {
    DartPluginRegistrant.ensureInitialized();

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    Timer.periodic(Duration(seconds: 5), (timer) {
      String currentTime = DateTime.now().toIso8601String();
      print('백그라운드 서비스 실행 중...: ${currentTime}');
      _showNotification("백그라운드 알림", "현재 시각: ${currentTime}");
      service.invoke('update', {"current_date": currentTime});
    });
  }

  static Future<void> _showNotification(String title, String body) async {
    const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails();
    const NotificationDetails notificationDetails =
    NotificationDetails(iOS: iosNotificationDetails);

    final uniqueNotificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _notificationsPlugin.show(
      uniqueNotificationId,
      title,
      body,
      notificationDetails,
    );
  }
}