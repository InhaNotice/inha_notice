/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-19
 */

import 'package:inha_notice/core/keys/custom_tab_keys.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/features/notice/domain/entities/major_type.dart';
import 'package:inha_notice/injection_container.dart' as di;
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';

abstract class CustomTabListUtils {
  static const List<String> kDefaultTabs = [
    CustomTabKeys.kWhole,
    CustomTabKeys.kMajor,
    CustomTabKeys.kScholarship,
    CustomTabKeys.kRecruitment,
    CustomTabKeys.kLibrary,
    CustomTabKeys.kInternational,
    CustomTabKeys.kSWUniv,
  ];

  static const List<String> kAdditionalTabs = [
    CustomTabKeys.kMajor2,
    CustomTabKeys.kMajor3,
    CustomTabKeys.kCollege,
    CustomTabKeys.kGraduateSchool,
    CustomTabKeys.kINHAHUSSUniv,
  ];

  /// **영문 탭 이름: 국문 탭 이름**
  static const Map<String, String> kTabMappingOnKey = {
    CustomTabKeys.kWhole: CustomTabKeys.WHOLE,
    CustomTabKeys.kMajor: CustomTabKeys.MAJOR,
    CustomTabKeys.kMajor2: CustomTabKeys.MAJOR2,
    CustomTabKeys.kMajor3: CustomTabKeys.MAJOR3,
    CustomTabKeys.kScholarship: CustomTabKeys.SCHOLARSHIP,
    CustomTabKeys.kRecruitment: CustomTabKeys.RECRUITMENT,
    CustomTabKeys.kLibrary: CustomTabKeys.LIBRARY,
    CustomTabKeys.kInternational: CustomTabKeys.INTERNATIONAL,
    CustomTabKeys.kSWUniv: CustomTabKeys.SWUNIV,
    CustomTabKeys.kINHAHUSSUniv: CustomTabKeys.INHAHUSS,
    CustomTabKeys.kCollege: CustomTabKeys.COLLEGE,
    CustomTabKeys.kGraduateSchool: CustomTabKeys.GRADUATESCHOOL,
  };

  static final Map<String, String> kTabMappingOnValue = Map.fromEntries(
      kTabMappingOnKey.entries
          .map((entry) => MapEntry(entry.value, entry.key)));

  static bool doesTabHaveSettingsPage(String tabName) {
    return tabName == CustomTabKeys.kMajor ||
        tabName == CustomTabKeys.kMajor2 ||
        tabName == CustomTabKeys.kMajor3 ||
        tabName == CustomTabKeys.kCollege ||
        tabName == CustomTabKeys.kGraduateSchool;
  }

  /// **Preference 로드가 필요한지 판단**
  /// 필요한 경우: MAJOR, MAJOR2, MAJOR3,COLLEGE, GRADUATESCHOOL
  static bool isUserSettingType(String noticeType) {
    return noticeType == CustomTabKeys.MAJOR ||
        noticeType == CustomTabKeys.MAJOR2 ||
        noticeType == CustomTabKeys.MAJOR3 ||
        noticeType == CustomTabKeys.COLLEGE ||
        noticeType == CustomTabKeys.GRADUATESCHOOL;
  }

  /// **학과 타입인지 판단**
  static bool isMajorType(String noticeType) {
    return noticeType == CustomTabKeys.MAJOR ||
        noticeType == CustomTabKeys.MAJOR2 ||
        noticeType == CustomTabKeys.MAJOR3;
  }

  /// **유저 설정 값이 있는 경우, 유저 설정 값을 불러옴.**
  /// noticeType이 유저 설정 값이 없는 경우, null을 리턴
  static String? loadUserSettingKey(String noticeType) {
    final SharedPrefsManager prefs = di.sl<SharedPrefsManager>();

    return switch (noticeType) {
      CustomTabKeys.MAJOR => prefs.getValue<String>(SharedPrefKeys.kMajorKey),
      CustomTabKeys.MAJOR2 => prefs.getValue<String>(SharedPrefKeys.kMajorKey2),
      CustomTabKeys.MAJOR3 => prefs.getValue<String>(SharedPrefKeys.kMajorKey3),
      CustomTabKeys.COLLEGE =>
        prefs.getValue<String>(SharedPrefKeys.kCollegeKey),
      CustomTabKeys.GRADUATESCHOOL =>
        prefs.getValue<String>(SharedPrefKeys.kGraduateSchoolKey),
      _ => null, // default 케이스
    };
  }

  /// 주어진 학과 키 ([majorKey])에 대응하는 UI 표시용 국문 학과명을 반환한다.
  ///
  /// 우선적으로 현재 지원되는 학과 목록([MajorType.majorMappingOnValue])에서 조회를 시도한다.
  /// 만약 해당 키가 존재하지 않을 경우(예: 공지사항 게시판 폐지, 통합 등), 미지원 학과 목록([MajorType.getUnsupportedMajorKoreanName])을 통해
  /// 통합된 학과명을 반환하거나 기본값('미지원 학과')을 반환한다.
  static String getMajorDisplayName(String majorKey) {
    final String? activeMajorName = MajorType.majorMappingOnValue[majorKey];
    if (activeMajorName != null) {
      return activeMajorName;
    }
    return MajorType.getUnsupportedMajorKoreanName(majorKey) ?? '미지원 학과';
  }
}
