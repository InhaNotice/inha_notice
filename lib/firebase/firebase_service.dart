import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';
import 'package:logger/logger.dart';

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

  // 캐싱된 구독된 토픽 목록
  Set<String> get _subscribedTopics =>
      SharedPrefsManager().getSubscribedTopics();

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

  /// 'all-users' 토픽 구독 (최초 1회)
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

  /// 개별 토픽 구독 (캐싱 활용)
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

  /// 개별 토픽 구독 해제 (캐싱 활용)
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

  /// 현재 토픽 구독 여부 확인
  bool _isSubscribedToTopic(String topic) {
    return _subscribedTopics.contains(topic);
  }

  /// 구독 리스트 추가
  void _addSubscribedTopic(String topic) {
    _subscribedTopics.add(topic);
    SharedPrefsManager().setSubscribedTopics(_subscribedTopics);
  }

  /// 구독 리스트 제거
  void _removeSubscribedTopic(String topic) {
    _subscribedTopics.remove(topic);
    SharedPrefsManager().setSubscribedTopics(_subscribedTopics);
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
    }
  }

  /// 이전 학과 토픽 해제 후 새로운 학과 토픽 구독하는 함수
  Future<void> updateMajorSubscription() async {
    try {
      final String? previousMajorKey =
          SharedPrefsManager().getPreviousMajorKey();
      final String? newMajorKey = SharedPrefsManager().getMajorKey();

      if (newMajorKey == null) {
        logger.e('🚨 Major key is null, cannot subscribe.');
        return;
      }

      /// `unsubscribeFromTopic` 메서드 내부에서 구독 여부 체크 후 실행하므로 중복 방지 가능
      if (previousMajorKey != null && previousMajorKey != newMajorKey) {
        await unsubscribeFromTopic(previousMajorKey);
      }

      /// 새로운 토픽 구독
      await subscribeToTopic(newMajorKey);
    } catch (e) {
      logger.e('🚨 Error handling FCM topic subscription: $e');
    }
  }
}
