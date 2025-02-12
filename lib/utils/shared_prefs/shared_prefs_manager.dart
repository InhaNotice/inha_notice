/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-12
 */
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// **SharedPrefsManager**
/// 이 클래스는 싱글톤으로 정의된 shared_preferences를 관리하는 클래스입니다.
class SharedPrefsManager {
  static final SharedPrefsManager _instance = SharedPrefsManager._internal();
  static final logger = Logger();

  SharedPreferences? _prefs;

  // 캐싱을 위한 변수 정의
  static String? _cachedPreviousMajorKey;
  static String? _cachedMajorKey;
  static bool? _cachedAcademicNotification;
  static bool? _cachedMajorNotification;
  static bool? _cachedInternationalNotification;
  static bool? _cachedSWUnivNotification;
  static Set<String>? _cachedSubscribedTopics;
  static bool? _cachedIsSubscribedToAllUsers;

  factory SharedPrefsManager() => _instance;

  SharedPrefsManager._internal();

  /// **SharedPreferences 초기화**
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _cachedMajorKey = _prefs?.getString('major-key');
    _cachedPreviousMajorKey = _prefs?.getString('previous-major-key');
    _cachedAcademicNotification =
        _prefs?.getBool('academic-notification') ?? false;
    _cachedMajorNotification = _prefs?.getBool('major-notification') ?? false;
    _cachedInternationalNotification =
        _prefs?.getBool('INTERNATIONAL') ?? false;
    _cachedSWUnivNotification = _prefs?.getBool('SWUNIV') ?? false;
    _cachedSubscribedTopics =
        _prefs?.getStringList('subscribed_topics')?.toSet() ?? {};
    _cachedIsSubscribedToAllUsers =
        _prefs?.getBool('isSubscribedToAllUsers') ?? false;
  }

  SharedPreferences? get prefs => _prefs;

  /// **학과 키 저장 (캐싱 추가)**
  Future<void> setMajorKey(String? currentMajorKey, String newMajorKey) async {
    if (currentMajorKey != null) {
      await _prefs?.setString('previous-major-key', currentMajorKey);
      _cachedPreviousMajorKey = currentMajorKey;
    }
    _cachedMajorKey = newMajorKey;
    await _prefs?.setString('major-key', newMajorKey);
    logger.d(
        "${runtimeType.toString()} - setMajorKey() 성공: '$currentMajorKey' to '$newMajorKey'");
  }

  /// **학과 키 가져오기 (캐싱 활용)**
  String? getMajorKey() {
    return _cachedMajorKey;
  }

  /// **이전 학과 키 가져오기 (캐싱 활용)**
  String? getPreviousMajorKey() {
    return _cachedPreviousMajorKey;
  }

  /// **학사 알림 설정 키 저장 (캐싱 추가)**
  Future<void> setAcademicNotificationOn(bool academicNotificationOn) async {
    _cachedAcademicNotification = academicNotificationOn;
    await _prefs?.setBool('academic-notification', academicNotificationOn);
  }

  /// **학사 알림 설정 키 가져오기 (캐싱 활용)**
  bool getAcademicNotificationOn() {
    return _cachedAcademicNotification ?? false;
  }

  /// **학과 알림 설정 키 저장 (캐싱 추가)**
  Future<void> setMajorNotificationOn(bool majorNotificationOn) async {
    _cachedMajorNotification = majorNotificationOn; // 캐싱
    await _prefs?.setBool('major-notification', majorNotificationOn);
  }

  /// **학과 알림 설정 키 가져오기 (캐싱 활용)**
  bool getMajorNotificationOn() {
    return _cachedMajorNotification ?? false;
  }

  /// **국제처 알림 설정 키 저장 (캐싱 추가)**
  Future<void> setInternationalNotificationOn(
      bool internationalNotificationOn) async {
    _cachedInternationalNotification = internationalNotificationOn;
    await _prefs?.setBool('INTERNATIONAL', internationalNotificationOn);
  }

  /// **국제처 알림 설정 키 가져오기 (캐싱 활용)**
  bool getInternationalNotificationOn() {
    return _cachedInternationalNotification ?? false;
  }

  /// **SW중심대학 알림 설정 키 저장 (캐싱 활용)**
  Future<void> setSWUnivNotificationOn(bool swunivNotificationOn) async {
    _cachedSWUnivNotification = swunivNotificationOn;
    await _prefs?.setBool('SWUNIV', swunivNotificationOn);
  }

  /// **SW중심대학 알림 설정 키 가져오기 (캐싱 활용)**
  bool getSWUnivNotificationOn() {
    return _cachedSWUnivNotification ?? false;
  }

  /// **구독된 토픽 목록 설정 (캐싱 추가)**
  Future<void> setSubscribedTopics(Set<String> subscribedTopics) async {
    _cachedSubscribedTopics = subscribedTopics;
    await _prefs?.setStringList('subscribed_topics', subscribedTopics.toList());
  }

  /// **구독된 토픽 목록 가져오기 (캐싱 활용)**
  Set<String> getSubscribedTopics() {
    _cachedSubscribedTopics ??=
        _prefs?.getStringList('subscribed_topics')?.toSet() ?? {};
    return _cachedSubscribedTopics!;
  }

  /// **'all-users' 토픽 구독 여부 설정**
  Future<void> setIsSubscribedToAllUsers(bool isSubscribed) async {
    _cachedIsSubscribedToAllUsers = isSubscribed;
    await _prefs?.setBool('isSubscribedToAllUsers', isSubscribed);
  }

  /// **'all-users' 토픽 구독 여부 확인**
  bool getIsSubscribedToAllUsers() {
    return _cachedIsSubscribedToAllUsers ?? false;
  }
}
