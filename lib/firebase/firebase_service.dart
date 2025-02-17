/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-17
 */
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inha_notice/main.dart';
import 'package:inha_notice/utils/read_notice/read_notice_manager.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:inha_notice/widgets/web_navigator.dart';
import 'package:logger/logger.dart';

/// **FirebaseService**
/// 이 클래스는 싱글톤으로 정의된 Firebase Cloud Messaging을 관리하는 클래스입니다.
class FirebaseService {
  // 싱글톤 인스턴스 정의
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Foreground 알림을 위해 FlutterLocalNotificationsPlugin 추가
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// 외부에서 객체 생성 방지
  FirebaseService._internal();

  FirebaseMessaging get messaging => _messaging;

  static final logger = Logger();

  /// **캐싱된 구독된 토픽 목록 가져오기**
  Set<String> get _subscribedTopics =>
      SharedPrefsManager().getSubscribedTopics();

  /// **Firebase 초기화 및 설정**
  /// 순서 보장: 알림 권한 요청 -> 'all-users' 구독 -> 플랫폼별 설정 -> FCM 토큰 출력
  Future<void> initialize() async {
    /// Android: 반드시 권한 요청이 _setupAndroidSettings보다 선행되어야 함
    /// iOS: 온보딩 파일에서 백그라운드로 처리(MacOS 호환성 때문)
    if (Platform.isAndroid) {
      await requestPermission();
    }
    // 'all-users' 토픽 구독
    await _subscribeToAppAnnouncements();

    // FCM 리스너 설정
    _setupMessageListeners();

    if (Platform.isIOS) {
      await _setupIOSSettings();
    } else if (Platform.isAndroid) {
      await _setupAndroidSettings();
    }

    _logDeviceToken(); // 디바이스 토큰 로그 출력
  }

  /// **FCM 리스너 설정**
  void _setupMessageListeners() {
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpenedApp);

    if (Platform.isAndroid) {
      FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
    }
  }

  /// **알림 권한 요청**
  Future<void> requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// **BottomNavBarPage에서 웹페이지 로딩을 위해 필요**
  /// 푸시알림 메시지를 읽어오는 함수
  Future<RemoteMessage?> getInitialNotification() async {
    return await FirebaseMessaging.instance.getInitialMessage();
  }

  /// **iOS 설정 초기화**
  Future<void> _setupIOSSettings() async {
    await _configureForegroundPresentationOptions();
  }

  /// **iOS Foreground 알림 표시 설정**
  Future<void> _configureForegroundPresentationOptions() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// **Android 설정 초기화**
  Future<void> _setupAndroidSettings() async {
    const androidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    final initializationSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _navigateToNotification(
              RemoteMessage(data: {"link": response.payload!}), true);
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', // Android 채널명
          'high_importance_notification',
          importance: Importance.max,
        ));
  }

  /// **디바이스 FCM 토큰 로그 출력**
  Future<void> _logDeviceToken() async {
    String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      logger.d('✅ FCM Token created successfully: $fcmToken');
    } else {
      logger.w('⚠️ FCM Token not available.');
    }
  }

  /// **'all-users' 토픽(앱 공지사항) 구독 (최초 1회)**
  Future<void> _subscribeToAppAnnouncements() async {
    bool isSubscribedUsers = SharedPrefsManager().getIsSubscribedToAllUsers();

    if (!isSubscribedUsers) {
      try {
        await _messaging.subscribeToTopic('all-users');
        await SharedPrefsManager().setIsSubscribedToAllUsers(true);
        logger.d("✅ Successfully subscribed to 'all-users' topic");
      } catch (e) {
        logger.e("🚨 Error subscribing to 'all-users' topic: $e");
      }
    }
  }

  /// **개별 토픽 구독 (캐싱 활용)**
  Future<void> subscribeToTopic(String topic) async {
    if (_isSubscribedToTopic(topic)) {
      logger.d("⚡ Already subscribed to '$topic' topic");
      return;
    }
    try {
      await _messaging.subscribeToTopic(topic);
      _addSubscribedTopic(topic);
      logger.d("✅ Successfully subscribed to '$topic' topic");
    } catch (e) {
      logger.e("🚨 Error subscribing to '$topic' topic: $e");
    }
  }

  /// **개별 토픽 구독 해제 (캐싱 활용)**
  Future<void> unsubscribeFromTopic(String topic) async {
    if (!_isSubscribedToTopic(topic)) {
      logger.d("⚡ Not subscribed to '$topic' topic");
      return;
    }
    try {
      await _messaging.unsubscribeFromTopic(topic);
      _removeSubscribedTopic(topic);
      logger.d("🔄 Unsubscribed from topic: '$topic'");
    } catch (e) {
      logger.e("🚨 Error unsubscribing from '$topic' topic: $e");
    }
  }

  /// **이전 학과 토픽 해제 후 새로운 학과 토픽 구독하는 함수**
  Future<void> updateMajorSubscription() async {
    try {
      final String? previousMajorKey =
          SharedPrefsManager().getPreviousMajorKey();
      final String? nextMajorKey = SharedPrefsManager().getMajorKey();

      if (nextMajorKey == null) {
        logger.w('🚨 Major key is null, cannot subscribe.');
        return;
      }

      // `unsubscribeFromTopic` 메서드 내부에서 구독 여부 체크 후 실행하므로 중복 방지 가능
      if (previousMajorKey != null && previousMajorKey != nextMajorKey) {
        await unsubscribeFromTopic(previousMajorKey);
      }

      // 새로운 토픽 구독
      await subscribeToTopic(nextMajorKey);
    } catch (e) {
      logger.e('🚨 Error handling FCM topic subscription: $e');
    }
  }

  /// **현재 토픽 구독 여부 확인(로컬에 저장된 리스트를 통해 확인)**
  bool _isSubscribedToTopic(String topic) {
    return _subscribedTopics.contains(topic);
  }

  /// **구독 리스트 추가(내부 확인용)**
  void _addSubscribedTopic(String topic) {
    _subscribedTopics.add(topic);
    SharedPrefsManager().setSubscribedTopics(_subscribedTopics);
  }

  /// **구독 리스트 제거(내부 확인용)**
  void _removeSubscribedTopic(String topic) {
    _subscribedTopics.remove(topic);
    SharedPrefsManager().setSubscribedTopics(_subscribedTopics);
  }

  /// **푸시 알림 클릭 시 WebPage로 이동(현재는 iOS만 지원)**
  void _handleNotificationOpenedApp(RemoteMessage message) {
    _navigateToNotification(message, true);
  }

  /// **알림 메시지 처리 함수**
  void _navigateToNotification(RemoteMessage message, bool isRunning) {
    if (!message.data.containsKey('link')) return;

    String link = message.data['link'];

    // 읽은 공지로 추가 (백그라운드 진행)
    if (message.data.containsKey('id')) {
      ReadNoticeManager.addReadNotice(message.data['id']);
    }

    // 앱이 실행 중일 때 푸시알림으로 웹페이지 이동을 핸들링
    if (isRunning) {
      WebNavigator.navigate(
        context: navigatorKey.currentContext!,
        url: link,
      );
    }
  }

  /// **백그라운드 메시지 핸들러**
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  /// **포그라운드 메시지 핸들러**
  void _showForegroundNotification(RemoteMessage message) async {
    if (message.notification == null) return;

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // Android 환경에서만 설정
    if (notification != null && android != null) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'high_importance_channel', // firebase_service.dart에 설정한 채널 ID와 동일해야 함
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: message.data['link'],
      );
    }
  }
}
