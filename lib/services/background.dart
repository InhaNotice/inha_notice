import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BackgroundService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initializeService() async {
    final service = FlutterBackgroundService();

    const DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const InitializationSettings initializationSettings =
    InitializationSettings(
      iOS: iosInitializationSettings,
    );
    await _notificationsPlugin.initialize(initializationSettings);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
    service.startService();
  }

  static bool onIosBackground(ServiceInstance service) {
    print('iOS 백그라운드 작업 실행 중...');
    return true;
  }

  static void onStart(ServiceInstance service) {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "백그라운드 서비스",
        content: "서비스 실행 중...",
      );
    }

    Timer.periodic(Duration(seconds: 5), (timer) {
      print('백그라운드 서비스 실행 중...');
      _showNotification("백그라운드 알림", "현재 시각: ${DateTime.now()}");
    });
  }

  static Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'background_service_channel',
      'Background Service Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await _notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}