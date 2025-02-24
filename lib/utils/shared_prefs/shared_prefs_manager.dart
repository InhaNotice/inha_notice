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

  // 캐싱 전략
  static final Map<String, dynamic> _cachedPrefs = {
    'subscribed_topics': <String>{},
    'isSubscribedToAllUsers': false,
    'previous-major-key': null,
    'major-key': null,
    'academic-notification': false,
    'major-notification': false,
    'INTERNATIONAL': false,
    'SWUNIV': false,
  };

  factory SharedPrefsManager() => _instance;

  SharedPrefsManager._internal();

  /// **SharedPreferences 초기화**
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await loadPreferences();
  }

  /// **모든 설정을 한 번에 불러와 캐싱**
  Future<void> loadPreferences() async {
    _cachedPrefs.forEach((key, value) {
      if (value is bool) {
        _cachedPrefs[key] = _prefs?.getBool(key) ?? value;
      } else if (value is String?) {
        _cachedPrefs[key] = _prefs?.getString(key);
      } else if (value is Set<String>) {
        _cachedPrefs[key] = _prefs?.getStringList(key)?.toSet() ?? value;
      }
    });
  }

  /// **알림 설정 통합 함수**
  Future<void> setPreference(String key, dynamic value) async {
    if (!_cachedPrefs.containsKey(key)) {
      logger.w("설정 키 '$key'가 존재하지 않습니다.");
      return;
    }

    _cachedPrefs[key] = value;

    if (value is bool) {
      await _prefs?.setBool(key, value);
    } else if (value is String) {
      await _prefs?.setString(key, value);
    } else if (value is Set<String>) {
      await _prefs?.setStringList(key, value.toList());
    }
  }

  Future<void> setMajorKey(String? currentMajorKey, String newMajorKey) async {
    if (currentMajorKey != null) {
      setPreference('previous-major-key', currentMajorKey);
    }
    setPreference('major-key', newMajorKey);
    logger.d(
        "${runtimeType.toString()} - setMajorKey() 성공: '$currentMajorKey' to '$newMajorKey'");
  }

  /// **설정 값 가져오기**
  dynamic getPreference(String key) {
    return _cachedPrefs[key];
  }
}
