/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-28
 */

import 'package:inha_notice/constants/app_theme_mode.dart';
import 'package:inha_notice/constants/shared_pref_keys/shared_pref_keys.dart';
import 'package:inha_notice/constants/university_keys/college_keys.dart';
import 'package:inha_notice/constants/university_keys/graduate_school_keys.dart';
import 'package:inha_notice/constants/university_keys/major_keys.dart';
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
    SharedPrefKeys.kUserThemeSetting: AppThemeMode.kSystem,
    // 구독 리스트
    SharedPrefKeys.kSubscribedTopics: <String>{},
    // 커스텀 탭바 리스트
    SharedPrefKeys.kCustomTabList: <String>[],
    // 앱 전체 공지
    SharedPrefKeys.kIsSubscribedToAllUsers: false,
    // 이전학과, 현재학과
    SharedPrefKeys.kPreviousMajorKey: null,
    SharedPrefKeys.kMajorKey: null,
    // 단과대
    SharedPrefKeys.kCollegeKey: null,
    // 대학원
    SharedPrefKeys.kGraduateSchoolKey: null,
    // 학사알림
    SharedPrefKeys.kAcademicNotification: false,
    // 학과알림
    SharedPrefKeys.kMajorNotification: false,

    // 학과 스타일(국제처, SW)
    SharedPrefKeys.INTERNATIONAL: false,
    SharedPrefKeys.SWUNIV: false,

    // 공과대학 (16)
    MajorKeys.MECH: false,
    MajorKeys.AEROSPACE: false,
    MajorKeys.NAOE: false,
    MajorKeys.IE: false,
    MajorKeys.CHEMENG: false,
    MajorKeys.INHAPOLY: false,
    MajorKeys.DMSE: false,
    MajorKeys.CIVIL: false,
    MajorKeys.ENVIRONMENT: false,
    MajorKeys.GEOINFO: false,
    MajorKeys.ARCH: false,
    MajorKeys.ENERES: false,
    MajorKeys.ELECTRICAL: false,
    MajorKeys.EE: false,
    MajorKeys.ICE: false,
    MajorKeys.EEE: false,
    MajorKeys.SSE: false,

    // 자연과학대학 (5)
    MajorKeys.MATH: false,
    MajorKeys.STATISTICS: false,
    MajorKeys.PHYSICS: false,
    MajorKeys.CHEMISTRY: false,
    MajorKeys.FOODNUTRI: false,

    // 경영대학 (4)
    MajorKeys.BIZ: false,
    MajorKeys.GFIBA: false,
    MajorKeys.APSL: false,
    MajorKeys.STAR: false,

    // 사범대학 (6)
    MajorKeys.KOREANEDU: false,
    MajorKeys.DELE: false,
    MajorKeys.SOCIALEDU: false,
    MajorKeys.PHYSICALEDU: false,
    MajorKeys.EDUCATION: false,
    MajorKeys.MATHED: false,

    // 사회과학대학 (7)
    MajorKeys.PUBLICAD: false,
    MajorKeys.POLITICAL: false,
    MajorKeys.COMM: false,
    MajorKeys.ECON: false,
    MajorKeys.CONSUMER: false,
    MajorKeys.CHILD: false,
    MajorKeys.WELFARE: false,

    // 문과대학 (8)
    MajorKeys.KOREAN: false,
    MajorKeys.HISTORY: false,
    MajorKeys.PHILOSOPHY: false,
    MajorKeys.CHINESE: false,
    MajorKeys.JAPAN: false,
    MajorKeys.ENGLISH: false,
    MajorKeys.FRANCE: false,
    MajorKeys.CULTURECM: false,

    // 의과대학 (1)
    MajorKeys.MEDICINE: false,

    // 간호대학 (1)
    MajorKeys.NURSING: false,

    // 예술체육대학 (4)
    MajorKeys.FINEARTS: false,
    MajorKeys.SPORT: false,
    MajorKeys.THEATREFILM: false,
    MajorKeys.FASHION: false,

    // 바이오시스템융합학부 (4)
    MajorKeys.BIO: false,
    MajorKeys.BIOLOGY: false,
    MajorKeys.BIOPHARM: false,
    MajorKeys.BIOMEDICAL: false,

    // 국제학부 (3)
    MajorKeys.SGCSA: false,
    MajorKeys.SGCSB: false,
    MajorKeys.SGCSC: false,

    // 미래융합대학 (4)
    MajorKeys.FCCOLLEGEA: false,
    MajorKeys.FCCOLLEGEB: false,
    MajorKeys.FCCOLLEGEC: false,
    MajorKeys.FCCOLLEGED: false,

    // 소프트웨어융합대학 (5)
    MajorKeys.DOAI: false,
    MajorKeys.SME: false,
    MajorKeys.DATASCIENCE: false,
    MajorKeys.DESIGNTECH: false,
    MajorKeys.CSE: false,

    // 프런티어창의대학 (5)
    MajorKeys.LAS: false,
    MajorKeys.ECS: false,
    MajorKeys.NCS: false,
    MajorKeys.CVGSOSCI: false,
    MajorKeys.CVGHUMAN: false,

    // 단과대 (9)
    CollegeKeys.GENERALEDU: false,
    CollegeKeys.ENGCOLLEAGE: false,
    CollegeKeys.NSCOLLEAGE: false,
    CollegeKeys.CBA: false,
    CollegeKeys.EDCOLLEGE: false,
    CollegeKeys.SSCOLLEGE: false,
    CollegeKeys.HACOLLEGE: false,
    CollegeKeys.ARTSPORTS: false,
    CollegeKeys.SWCC: false,

    // 대학원 (10)
    GraduateSchoolKeys.GRAD: false,
    GraduateSchoolKeys.ENGRAD: false,
    GraduateSchoolKeys.MBA: false,
    GraduateSchoolKeys.EDUGRAD: false,
    GraduateSchoolKeys.ADMGRAD: false,
    GraduateSchoolKeys.COUNSELGRAD: false,
    GraduateSchoolKeys.GSPH: false,
    GraduateSchoolKeys.ILS: false,
    GraduateSchoolKeys.GSL: false,
    GraduateSchoolKeys.IMIS: false,
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
      logger.d('✅ Preference 성공적으로 저장 - $key: $value');
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
      String? currentMajorKey, String newMajorKey) async {
    if (currentMajorKey != null) {
      setPreference(SharedPrefKeys.kPreviousMajorKey, currentMajorKey);
    }
    setPreference(SharedPrefKeys.kMajorKey, newMajorKey);
    logger.d(
        "${runtimeType.toString()} - setMajorKey() 성공: '$currentMajorKey' to '$newMajorKey'");
  }
}
