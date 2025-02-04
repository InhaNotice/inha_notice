import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class FirebaseService {
  // 싱글톤 인스턴스 정의
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  // Private 멤버변수 선언
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // 외부에서 객체 생성 방지
  FirebaseService._internal();

  // Getter 함수; FirebaseService.messaging로 사용
  FirebaseMessaging get messaging => _messaging;

  static final logger = Logger();

  /// Firebase 초기화 및 기본 구독 설정
  Future<void> initialize() async {
    await _requestPermission();
    await _subscribeToAllUsersAndNotices();

    FirebaseMessaging.onMessage.listen(_onForegroundMessageHandler);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

  /// 알림 권한 요청
  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// 'all-users & all-notices' 토픽 구독 (최초 1회)
  Future<void> _subscribeToAllUsersAndNotices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSubscribedUsers = prefs.getBool('isSubscribedToAllUsers') ?? false;
    bool isSubscribedNotices =
        prefs.getBool('isSubscribedToAllNotices') ?? false;

    // 'all-users' 토픽은 앱 공지사항 관련 알림
    if (!isSubscribedUsers) {
      try {
        await _messaging.subscribeToTopic('all-users');
        await prefs.setBool('isSubscribedToAllUsers', true);
        logger.d("✅ Successfully subscribed to 'all-users' topic");
      } catch (e) {
        logger.e("🚨 Error subscribing to 'all-users' topic: $e");
      }
    }

    // 'all-notices' 토픽은 학사 공지사항 관련 알림
    if (!isSubscribedNotices) {
      try {
        await _messaging.subscribeToTopic('all-notices');
        await prefs.setBool('isSubscribedToAllNotices', true);
        logger.d("✅ Successfully subscribed to 'all-notices' topic");
      } catch (e) {
        logger.e("🚨 Error subscribing to 'all-notices' topic: $e");
      }
    }
  }

  /// 개별 토픽 구독
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      logger.d("✅ Successfully subscribed to $topic topic");
    } catch (e) {
      logger.e("🚨 Error subscribing to $topic topic: $e");
    }
  }

  /// 개별 토픽 구독 해제
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      logger.d("🔄 Unsubscribed from topic: $topic");
    } catch (e) {
      logger.e("🚨 Error unsubscribing from $topic topic: $e");
    }
  }

  /// 백그라운드 메시지 핸들러
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    logger.d("📩 Handling a background message: ${message.messageId}");
  }

  /// 포그라운드 메시지 핸들러
  void _onForegroundMessageHandler(RemoteMessage message) async {
    logger.d('📩 Foreground message received!');
    logger.d('Message data: ${message.data}');

    if (message.notification != null) {
      logger.d('🔔 Notification: ${message.notification}');
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate();
      }
    }
  }
}
