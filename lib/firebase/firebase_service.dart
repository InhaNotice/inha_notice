import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import 'package:inha_notice/main.dart';
import 'package:inha_notice/screens/web_page.dart';
import 'package:inha_notice/screens/onboarding/onboarding_screen.dart';

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

  /// **Firebase 초기화 및 기본 구독 설정**
  Future<void> initialize() async {
    await _requestPermission();
    await _subscribeToAllUsersAndNotices();

    FirebaseMessaging.onMessage.listen(_onForegroundMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // 앱이 종료된 상태에서 알림 클릭 시 데이터 처리
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage, isAppTerminated: true);
    }

    if (!Platform.isIOS) {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }

    if (Platform.isAndroid) {
      // ✅ 포그라운드 알림 클릭 이벤트 핸들러 추가
      const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings("@mipmap/ic_launcher");

      final InitializationSettings initializationSettings =
      InitializationSettings(android: androidSettings);

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // 알림 클릭 시 실행할 코드
          logger.d("🔔 Foreground Notification Clicked: ${response.payload}");

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

    // iOS Foreground 알림 옵션 설정 (Android에선 불필요)
    if (Platform.isIOS) {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // iOS인 경우 APNs 토큰을 설정
    if (Platform.isIOS) {
      try {
        String? apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          logger.d('✅ APNS Token and FCM Token were successfully created.');
        } else {
          logger.w(
              '⚠️ APNS Token not set. Ensure network access & notifications are enabled.');
        }
      } catch (e) {
        logger.e('🚨 Error fetching APNS token: $e');
      }
    }

    // Android인 경우 메시지 출력
    if (Platform.isAndroid) {
      String? fcmToken = await messaging.getToken();
      if (fcmToken != null) {
        logger.d('✅ Android FCM Token created successfully: $fcmToken');
      } else {
        logger.w('⚠️ Android FCM Token not available.');
      }
    }
  }
  /// **푸시 알림 클릭 시 WebPage로 이동**
  void _onMessageOpenedApp(RemoteMessage message) {
    _handleMessage(message, isAppTerminated: false);
  }

  /// **알림 메시지 처리 함수**
  void _handleMessage(RemoteMessage message, {required bool isAppTerminated}) {
    logger.d("📩 Notification Clicked: ${message.data}");

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
          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => WebPage(url: link)),
          );
        });
      } else {
        if (navigatorKey.currentState?.canPop() ?? false) {
          navigatorKey.currentState?.pop();
        }
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => WebPage(url: link)),
        );
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

  /// **'all-users' 토픽 구독 (최초 1회)**
  Future<void> _subscribeToAllUsersAndNotices() async {
    bool isSubscribedUsers = SharedPrefsManager().getIsSubscribedToAllUsers();

    // 'all-users' 토픽은 앱 공지사항 관련 알림
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

  /// **백그라운드 메시지 핸들러**
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    logger.d("📩 Handling a background message: ${message.messageId}");
  }

  /// **포그라운드 메시지 핸들러**
  void _onForegroundMessageHandler(RemoteMessage message) async {
    logger.d('📩 Foreground message received!');
    logger.d('Message data: ${message.data}');

    if (message.notification != null) {
      logger.d('🔔 Notification: ${message.notification}');

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
  /// **이전 학과 토픽 해제 후 새로운 학과 토픽 구독하는 함수**
  Future<void> updateMajorSubscription() async {
    try {
      final String? previousMajorKey =
          SharedPrefsManager().getPreviousMajorKey();
      final String? newMajorKey = SharedPrefsManager().getMajorKey();

      if (newMajorKey == null) {
        logger.e('🚨 Major key is null, cannot subscribe.');
        return;
      }

      // `unsubscribeFromTopic` 메서드 내부에서 구독 여부 체크 후 실행하므로 중복 방지 가능
      if (previousMajorKey != null && previousMajorKey != newMajorKey) {
        await unsubscribeFromTopic(previousMajorKey);
      }

      // 새로운 토픽 구독
      await subscribeToTopic(newMajorKey);
    } catch (e) {
      logger.e('🚨 Error handling FCM topic subscription: $e');
    }
  }
}
