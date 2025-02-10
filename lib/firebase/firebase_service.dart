/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-10
 */
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inha_notice/main.dart';
import 'package:inha_notice/screens/onboarding/onboarding_screen.dart';
import 'package:inha_notice/screens/web_page.dart';
import 'package:inha_notice/utils/read_notice/read_notice_manager.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:logger/logger.dart';

/// **FirebaseService**
/// 이 클래스는 싱글톤으로 정의된 Firebase Cloud Messaging을 관리하는 클래스입니다.
class FirebaseService {
  // 싱글톤 인스턴스 정의
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  // Private 멤버변수 선언
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Foreground 알림을 위해 FlutterLocalNotificationsPlugin 추가
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 외부에서 객체 생성 방지
  FirebaseService._internal();

  // Getter 함수; FirebaseService.messaging로 사용
  FirebaseMessaging get messaging => _messaging;

  static final logger = Logger();

  /// **캐싱된 구독된 토픽 목록 가져오기**
  Set<String> get _subscribedTopics =>
      SharedPrefsManager().getSubscribedTopics();

  /// **Firebase 초기화 및 기본 구독 및 알림 설정**
  Future<void> initialize() async {
    // 알림 권한 요청
    await _requestPermission();
    // 'all-users' 토픽 구독
    await _subscribeToAllUsers();

    // Foreground 알림 설정
    FirebaseMessaging.onMessage.listen(_onForegroundMessageHandler);
    // 푸시알림 클릭시 WebPage 로드 설정
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // 앱 종료된 상태에서 푸시알림 클릭시 이벤트 처리
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage, isAppTerminated: true);
    }

    // iOS Background 알림 설정
    if (!Platform.isIOS) {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    }

    // iOS Foreground 알림 옵션 설정
    if (Platform.isIOS) {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Android 포그라운드 및 백그라운드 알림 설정
    if (Platform.isAndroid) {
      // 포그라운드 알림 클릭 이벤트 핸들러 추가
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings("@mipmap/ic_launcher");

      final InitializationSettings initializationSettings =
          InitializationSettings(android: androidSettings);

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null) {
            _handleMessage(RemoteMessage(data: {"link": response.payload!}),
                isAppTerminated: false);
          }
        },
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(const AndroidNotificationChannel(
              'high_importance_channel', 'high_importance_notification',
              importance: Importance.max));
    }

    // iOS인 경우 APNs 토큰을 설정
    if (Platform.isIOS) {
      try {
        String? apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          logger.d(
              'FirebaseService - initialize() 성공: ✅ APNS Token and FCM Token were successfully created.');
        } else {
          logger.w(
              'FirebaseService - initialize() 경고: ⚠️ APNS Token not set. Ensure network access & notifications are enabled.');
        }
      } catch (e) {
        logger.e(
            'FirebaseService - initialize() 오류: 🚨 Error fetching APNS token: $e');
      }
    }

    // Android인 경우 Device 토큰 출력
    if (Platform.isAndroid) {
      String? fcmToken = await messaging.getToken();
      if (fcmToken != null) {
        logger.d(
            'FirebaseService - initialize() 성공: ✅ Android FCM Token created successfully: $fcmToken');
      } else {
        logger.w(
            'FirebaseService - initialize() 경고: ⚠️ Android FCM Token not available.');
      }
    }
  }

  /// **알림 권한 요청**
  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// **'all-users' 토픽(앱 공지사항) 구독 (최초 1회)**
  Future<void> _subscribeToAllUsers() async {
    bool isSubscribedUsers = SharedPrefsManager().getIsSubscribedToAllUsers();

    if (!isSubscribedUsers) {
      try {
        await _messaging.subscribeToTopic('all-users');
        await SharedPrefsManager().setIsSubscribedToAllUsers(true);
        logger.d(
            "FirebaseService - _subscribeToAllUsers() 성공: ✅ Successfully subscribed to 'all-users' topic");
      } catch (e) {
        logger.e(
            "FirebaseService - _subscribeToAllUsers() 오류: 🚨 Error subscribing to 'all-users' topic: $e");
      }
    }
  }

  /// **개별 토픽 구독 (캐싱 활용)**
  Future<void> subscribeToTopic(String topic) async {
    if (_isSubscribedToTopic(topic)) {
      logger.d(
          "FirebaseService - subscribeToTopic() 알림: ⚡ Already subscribed to '$topic' topic");
      return;
    }
    try {
      await _messaging.subscribeToTopic(topic);
      _addSubscribedTopic(topic);
      logger.d(
          "FirebaseService - subscribeToTopic() 성공: ✅ Successfully subscribed to '$topic' topic");
    } catch (e) {
      logger.e(
          "FirebaseService - subscribeToTopic() 에러: 🚨 Error subscribing to '$topic' topic: $e");
    }
  }

  /// **개별 토픽 구독 해제 (캐싱 활용)**
  Future<void> unsubscribeFromTopic(String topic) async {
    if (!_isSubscribedToTopic(topic)) {
      logger.d(
          "FirebaseService - unsubscribeFromTopic() 알림: ⚡ Not subscribed to '$topic' topic");
      return;
    }
    try {
      await _messaging.unsubscribeFromTopic(topic);
      _removeSubscribedTopic(topic);
      logger.d(
          "FirebaseService - unsubscribeFromTopic() 성공: 🔄 Unsubscribed from topic: '$topic'");
    } catch (e) {
      logger.e(
          "FirebaseService - unsubscribeFromTopic() 오류: 🚨 Error unsubscribing from '$topic' topic: $e");
    }
  }

  /// **현재 토픽 구독 여부 확인**
  bool _isSubscribedToTopic(String topic) {
    return _subscribedTopics.contains(topic);
  }

  /// **구독 리스트 추가**
  void _addSubscribedTopic(String topic) {
    _subscribedTopics.add(topic);
    SharedPrefsManager().setSubscribedTopics(_subscribedTopics);
  }

  /// **구독 리스트 제거**
  void _removeSubscribedTopic(String topic) {
    _subscribedTopics.remove(topic);
    SharedPrefsManager().setSubscribedTopics(_subscribedTopics);
  }

  /// **이전 학과 토픽 해제 후 새로운 학과 토픽 구독하는 함수**
  Future<void> updateMajorSubscription() async {
    try {
      final String? previousMajorKey =
          SharedPrefsManager().getPreviousMajorKey();
      final String? newMajorKey = SharedPrefsManager().getMajorKey();

      if (newMajorKey == null) {
        logger.w(
            'FirebaseService - updateMajorSubscription() 경고: 🚨 Major key is null, cannot subscribe.');
        return;
      }

      // `unsubscribeFromTopic` 메서드 내부에서 구독 여부 체크 후 실행하므로 중복 방지 가능
      if (previousMajorKey != null && previousMajorKey != newMajorKey) {
        await unsubscribeFromTopic(previousMajorKey);
      }

      // 새로운 토픽 구독
      await subscribeToTopic(newMajorKey);
    } catch (e) {
      logger.e(
          'FirebaseService - updateMajorSubscription() 오류: 🚨 Error handling FCM topic subscription: $e');
    }
  }

  /// **푸시 알림 클릭 시 WebPage로 이동**
  void _onMessageOpenedApp(RemoteMessage message) {
    _handleMessage(message, isAppTerminated: false);
  }

  /// **알림 메시지 처리 함수**
  void _handleMessage(RemoteMessage message, {required bool isAppTerminated}) {
    if (message.data.containsKey('link')) {
      String link = message.data['link'];

      if (isAppTerminated) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
          (route) => false,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (navigatorKey.currentState?.canPop() ?? false) {
            navigatorKey.currentState?.pop();
          }
          // 읽은 공지로 추가 (백그라운드 진행)
          if (message.data.containsKey('id')) {
            ReadNoticeManager.addReadNotice(message.data['id']);
          }
          // 웹페이지 로드
          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => WebPage(url: link)),
          );
        });
      } else {
        if (navigatorKey.currentState?.canPop() ?? false) {
          navigatorKey.currentState?.pop();
        }
        // 읽은 공지 추가 (백그라운드 진행)
        if (message.data.containsKey('id')) {
          ReadNoticeManager.addReadNotice(message.data['id']);
        }
        // 웹페이지 로드
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => WebPage(url: link)),
        );
      }
    }
  }

  /// **백그라운드 메시지 핸들러**
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  /// **포그라운드 메시지 핸들러**
  void _onForegroundMessageHandler(RemoteMessage message) async {
    if (message.notification != null) {
      // Foreground에서도 알림을 표시하도록 flutter_local_notifications 사용
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

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
}
