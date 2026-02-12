/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/notice/domain/entities/major_type.dart';
import 'package:inha_notice/injection_container.dart' as di;

/// 커스텀 탭의 종류를 정의하는 enum이다.
///
/// 각 탭은 [key] (한글 UI용)와 [noticeType] (영문 타입 식별자)을 가진다.
enum CustomTabType {
  whole(key: '학사', noticeType: 'WHOLE'),
  major(key: '학과', noticeType: 'MAJOR'),
  major2(key: '학과2', noticeType: 'MAJOR2'),
  major3(key: '학과3', noticeType: 'MAJOR3'),
  scholarship(key: '장학', noticeType: 'SCHOLARSHIP'),
  recruitment(key: '모집/채용', noticeType: 'RECRUITMENT'),
  library(key: '정석', noticeType: 'LIBRARY'),
  international(key: '국제처', noticeType: 'INTERNATIONAL'),
  swUniv(key: 'SW중심대학사업단', noticeType: 'SWUNIV'),
  inhaHussUniv(key: '기후위기대응사업단', noticeType: 'INHAHUSS'),
  college(key: '단과대', noticeType: 'COLLEGE'),
  graduateSchool(key: '대학원', noticeType: 'GRADUATESCHOOL');

  final String key;
  final String noticeType;

  const CustomTabType({required this.key, required this.noticeType});

  /// 설정 페이지가 있는 탭인지 여부
  bool get hasSettingsPage =>
      this == major ||
      this == major2 ||
      this == major3 ||
      this == college ||
      this == graduateSchool;

  /// Preference 로드가 필요한 타입인지 여부
  bool get isUserSettingType => hasSettingsPage;

  /// 학과 타입인지 여부
  bool get isMajorType => this == major || this == major2 || this == major3;

  /// 유저 설정 SharedPreferences 키를 반환한다.
  String? get userSettingPrefKey => switch (this) {
        major => SharedPrefKeys.kMajorKey,
        major2 => SharedPrefKeys.kMajorKey2,
        major3 => SharedPrefKeys.kMajorKey3,
        college => SharedPrefKeys.kCollegeKey,
        graduateSchool => SharedPrefKeys.kGraduateSchoolKey,
        _ => null,
      };

  // ---------------------------------------------------------------------------
  // Static: 기본/추가 탭 목록
  // ---------------------------------------------------------------------------

  static const List<String> kDefaultTabs = [
    '학사',
    '학과',
    '장학',
    '모집/채용',
    '정석',
    '국제처',
    'SW중심대학사업단',
  ];

  static const List<String> kAdditionalTabs = [
    '학과2',
    '학과3',
    '단과대',
    '대학원',
    '기후위기대응사업단',
  ];

  // ---------------------------------------------------------------------------
  // Static: 매핑 (기존 API 호환)
  // ---------------------------------------------------------------------------

  /// 한글 키 → 영문 noticeType 매핑
  static final Map<String, String> kTabMappingOnKey = {
    for (final tab in values) tab.key: tab.noticeType,
  };

  /// 영문 noticeType → 한글 키 매핑
  static final Map<String, String> kTabMappingOnValue = {
    for (final tab in values) tab.noticeType: tab.key,
  };

  // ---------------------------------------------------------------------------
  // Static: 문자열 기반 조회 (기존 API 호환)
  // ---------------------------------------------------------------------------

  /// 한글 키로 enum을 찾는다.
  static CustomTabType? fromKey(String key) => _keyMap[key];

  /// 영문 noticeType으로 enum을 찾는다.
  static CustomTabType? fromNoticeType(String noticeType) =>
      _noticeTypeMap[noticeType];

  static final Map<String, CustomTabType> _keyMap = {
    for (final tab in values) tab.key: tab,
  };

  static final Map<String, CustomTabType> _noticeTypeMap = {
    for (final tab in values) tab.noticeType: tab,
  };

  /// 한글 키 기준으로 설정 페이지가 있는지 판단한다.
  static bool doesTabHaveSettingsPage(String tabName) =>
      fromKey(tabName)?.hasSettingsPage ?? false;

  /// 영문 noticeType 기준으로 유저 설정 타입인지 판단한다.
  static bool isUserSettingTypeOf(String noticeType) =>
      fromNoticeType(noticeType)?.isUserSettingType ?? false;

  /// 영문 noticeType 기준으로 학과 타입인지 판단한다.
  static bool isMajorTypeOf(String noticeType) =>
      fromNoticeType(noticeType)?.isMajorType ?? false;

  /// 유저 설정 값이 있는 경우, 유저 설정 값을 불러온다.
  /// noticeType이 유저 설정 값이 없는 경우, null을 리턴한다.
  static String? loadUserSettingKey(String noticeType) {
    final tab = fromNoticeType(noticeType);
    if (tab == null) return null;
    final prefKey = tab.userSettingPrefKey;
    if (prefKey == null) return null;
    final SharedPrefsManager prefs = di.sl<SharedPrefsManager>();
    return prefs.getValue<String>(prefKey);
  }

  /// 주어진 학과 키 ([majorKey])에 대응하는 UI 표시용 국문 학과명을 반환한다.
  static String getMajorDisplayName(String majorKey) {
    final String? activeMajorName = MajorType.majorMappingOnValue[majorKey];
    if (activeMajorName != null) {
      return activeMajorName;
    }
    return MajorType.getUnsupportedMajorKoreanName(majorKey) ?? '미지원 학과';
  }
}
