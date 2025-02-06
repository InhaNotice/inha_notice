import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static final SharedPrefsManager _instance = SharedPrefsManager._internal();
  SharedPreferences? _prefs;

  // 캐싱을 위한 변수
  static String? _cachedMajorKey;
  static bool? _cachedAcademicNotification;
  static bool? _cachedMajorNotification;

  factory SharedPrefsManager() => _instance;

  SharedPrefsManager._internal();

  /// SharedPreferences 초기화
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    // 초기화 시 캐싱 값 로드
    _cachedMajorKey = _prefs?.getString('major_key');
    _cachedAcademicNotification =
        _prefs?.getBool('academic_notification') ?? false;
    _cachedMajorNotification = _prefs?.getBool('major_notification') ?? false;
  }

  SharedPreferences? get prefs => _prefs;

  /// 학과 키 저장 (캐싱 추가)
  Future<void> setMajorKey(String majorKey) async {
    _cachedMajorKey = majorKey; // 캐싱
    await _prefs?.setString('major_key', majorKey);
  }

  /// 학과 키 가져오기 (캐싱 활용)
  String? getMajorKey() {
    return _cachedMajorKey;
  }

  /// 학사 알림 설정 키 저장 (캐싱 추가)
  Future<void> setAcademicNotificationOn(bool academicNotificationOn) async {
    _cachedAcademicNotification = academicNotificationOn; // 캐싱
    await _prefs?.setBool('academic_notification', academicNotificationOn);
  }

  /// 학사 알림 설정 키 가져오기 (캐싱 활용)
  bool getAcademicNotificationOn() {
    return _cachedAcademicNotification ?? false;
  }

  /// 학과 알림 설정 키 저장 (캐싱 추가)
  Future<void> setMajorNotificationOn(bool majorNotificationOn) async {
    _cachedMajorNotification = majorNotificationOn; // 캐싱
    await _prefs?.setBool('major_notification', majorNotificationOn);
  }

  /// 학과 알림 설정 키 가져오기 (캐싱 활용)
  bool getMajorNotificationOn() {
    return _cachedMajorNotification ?? false;
  }
}
