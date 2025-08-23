/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-23
 */

import 'package:inha_notice/core/keys/custom_tab_keys.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
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
    String? userSettingKey;
    switch (noticeType) {
      // 학과
      case CustomTabKeys.MAJOR:
        userSettingKey =
            SharedPrefsManager().getPreference(SharedPrefKeys.kMajorKey);
        break;
      case CustomTabKeys.MAJOR2:
        userSettingKey =
            SharedPrefsManager().getPreference(SharedPrefKeys.kMajorKey2);
        break;
      case CustomTabKeys.MAJOR3:
        userSettingKey =
            SharedPrefsManager().getPreference(SharedPrefKeys.kMajorKey3);
        break;
      // 단과대
      case CustomTabKeys.COLLEGE:
        userSettingKey =
            SharedPrefsManager().getPreference(SharedPrefKeys.kCollegeKey);
        break;
      // 대학원
      case CustomTabKeys.GRADUATESCHOOL:
        userSettingKey = SharedPrefsManager()
            .getPreference(SharedPrefKeys.kGraduateSchoolKey);
        break;
      default:
        break;
    }
    return userSettingKey;
  }
}
