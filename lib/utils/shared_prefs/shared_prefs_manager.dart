/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-23
 */

import 'package:inha_notice/core/constants/app_theme_constant.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/utils/university_utils/college_utils.dart';
import 'package:inha_notice/utils/university_utils/graduate_school_utils.dart';
import 'package:inha_notice/utils/university_utils/major_utils.dart';
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
    // 테마 모드 (기본값: system)
    SharedPrefKeys.kUserThemeSetting: AppThemeConstant.kSystem,
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
    for (final value in MajorUtils.kMajorValueList) {
      majorPrefs[value] = false;
    }
    return majorPrefs;
  }

  /// **단과대 설정값 로딩**
  static Map<String, bool> _buildCollegePrefs() {
    final Map<String, bool> collegePrefs = {};
    for (final value in CollegeUtils.kCollegeValueList) {
      collegePrefs[value] = false;
    }
    return collegePrefs;
  }

  /// **대학원 설정값 로딩**
  static Map<String, bool> _buildGraduateSchoolPrefs() {
    final Map<String, bool> graduatePrefs = {};
    for (final value in GraduateSchoolUtils.kGraduateSchoolValueList) {
      graduatePrefs[value] = false;
    }
    return graduatePrefs;
  }

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
        _cachedPrefs[key] = _prefs?.getString(key) ?? value;
      } else if (value is List<String>) {
        _cachedPrefs[key] = _prefs?.getStringList(key) ?? value;
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
      // logger.d('✅ Preference 성공적으로 저장 - $key: $value');
    } catch (e) {
      logger.e('❌ Preference 저장 중 에러가 발생: $e');
    }
  }

  /// **설정 값 가져오기**
  dynamic getPreference(String key) {
    return _cachedPrefs[key];
  }

  /// **새로운 학과 설정**
  Future<void> setMajorPreference(
      String? currentMajorKey, String newMajorKey, String majorKeyType) async {
    setPreference(majorKeyType, newMajorKey);
    logger.d(
        "${runtimeType.toString()} - setMajorKey() 성공: '$currentMajorKey' to '$newMajorKey'");
  }
}
