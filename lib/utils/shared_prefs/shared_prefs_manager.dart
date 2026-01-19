/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-19
 */

import 'package:inha_notice/core/config/app_theme_type.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/app_logger.dart';
import 'package:inha_notice/features/notice/domain/entities/college_type.dart';
import 'package:inha_notice/features/notice/domain/entities/graduate_school_type.dart';
import 'package:inha_notice/features/notice/domain/entities/major_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// **SharedPrefsManager**
/// 이 클래스는 싱글톤으로 정의된 shared_preferences를 관리하는 클래스입니다.
class SharedPrefsManager {
  SharedPreferences? _prefs;
  SharedPrefsManager(this._prefs);

  // 캐싱 전략
  static final Map<String, dynamic> _cache = {
    // 테마 모드 (기본값: system)
    SharedPrefKeys.kUserThemeSetting: AppThemeType.system.text,
    // 캐시 용량
    SharedPrefKeys.kCacheCapacity: null,
    // 구독 리스트
    SharedPrefKeys.kSubscribedTopics: <String>{},
    // 커스텀 탭바 리스트
    SharedPrefKeys.kCustomTabList: <String>[],
    // 앱 전체 공지
    SharedPrefKeys.kIsSubscribedToAllUsers: false,
    // 이전학과, 현재학과
    SharedPrefKeys.kPreviousMajorKey: null,
    SharedPrefKeys.kMajorKey: null,
    SharedPrefKeys.kMajorKey2: null,
    SharedPrefKeys.kMajorKey3: null,
    // 단과대
    SharedPrefKeys.kCollegeKey: null,
    // 대학원
    SharedPrefKeys.kGraduateSchoolKey: null,
    // 전체공지, 장학, 모집/채용
    SharedPrefKeys.kAcademicNotification: false,
    SharedPrefKeys.kScholarship: false,
    SharedPrefKeys.kRecruitment: false,
    // 학과알림
    SharedPrefKeys.kMajorNotification: false,
    // 학과 스타일(국제처, SW, INHAHUSS)
    SharedPrefKeys.INTERNATIONAL: false,
    SharedPrefKeys.SWUNIV: false,
    SharedPrefKeys.INHAHUSS: false,
    // 학사일정 알림
    SharedPrefKeys.kUndergraduateScheduleD1Notification: false,
    SharedPrefKeys.kUndergraduateScheduleDDNotification: false,
    // 정석학술정보관
    SharedPrefKeys.kLibrary: false,

    // 학과
    ..._buildMajorPrefs(),

    // 단과대 (9)
    ..._buildCollegePrefs(),

    // 대학원 (10)
    ..._buildGraduateSchoolPrefs(),
  };

  /// **학과 설정값 로딩**
  static Map<String, bool> _buildMajorPrefs() {
    final Map<String, bool> majorPrefs = {};
    for (final value in MajorType.majorValueList) {
      majorPrefs[value] = false;
    }
    return majorPrefs;
  }

  /// **단과대 설정값 로딩**
  static Map<String, bool> _buildCollegePrefs() {
    final Map<String, bool> collegePrefs = {};
    for (final key in CollegeType.keys) {
      collegePrefs[key] = false;
    }
    return collegePrefs;
  }

  /// **대학원 설정값 로딩**
  static Map<String, bool> _buildGraduateSchoolPrefs() {
    final Map<String, bool> graduatePrefs = {};
    for (final key in GraduateSchoolType.graduateSchoolKeyList) {
      graduatePrefs[key] = false;
    }
    return graduatePrefs;
  }

  /// **SharedPreferences 초기화**
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await loadPreferences();
  }

  /// **모든 설정을 한 번에 불러와 캐싱**
  Future<void> loadPreferences() async {
    _cache.forEach((key, value) {
      if (value is bool) {
        _cache[key] = _prefs?.getBool(key) ?? value;
      } else if (value is String?) {
        _cache[key] = _prefs?.getString(key) ?? value;
      } else if (value is List<String>) {
        _cache[key] = _prefs?.getStringList(key) ?? value;
      } else if (value is Set<String>) {
        _cache[key] = _prefs?.getStringList(key)?.toSet() ?? value;
      }
    });
  }

  /// **알림 설정 통합 함수**
  Future<void> setValue<T>(String key, T value) async {
    if (!_cache.containsKey(key)) {
      AppLogger.w("설정 키 '$key'가 존재하지 않습니다.");
      return;
    }

    _cache[key] = value;

    try {
      if (value is bool) {
        await _prefs?.setBool(key, value);
      } else if (value is String) {
        await _prefs?.setString(key, value);
      } else if (value is Set<String>) {
        await _prefs?.setStringList(key, value.toList());
      } else if (value is List<String>) {
        await _prefs?.setStringList(key, value.toList());
      }
      AppLogger.d('✅ Preference 성공적으로 저장 - $key: $value');
    } catch (e) {
      AppLogger.e('❌ Preference 저장 중 에러가 발생: $e');
    }
  }

  /// 설정 값 가져오기
  /// 사용법 예시: final isDark = SharedPrefsManager().getValue<bool>(Keys.isDark);
  T? getValue<T>(String key) {
    final value = _cache[key];
    if (value is T) {
      return value;
    }
    return null;
  }

  /// **새로운 학과 설정**
  Future<void> setMajorPreference(
      String? currentMajorKey, String newMajorKey, String majorKeyType) async {
    setValue<String>(majorKeyType, newMajorKey);
    AppLogger.d(
        "${runtimeType.toString()} - setMajorKey() 성공: '$currentMajorKey' to '$newMajorKey'");
  }
}
