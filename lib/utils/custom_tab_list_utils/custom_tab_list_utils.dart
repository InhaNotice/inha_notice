/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-03-01
 */
import 'package:inha_notice/constants/custom_tab_list/custom_tab_list_keys.dart';
import 'package:inha_notice/constants/shared_pref_keys/shared_pref_keys.dart';
import 'package:inha_notice/utils/shared_prefs/shared_prefs_manager.dart';

abstract class CustomTabListUtils {
  static const List<String> kDefaultTabs = [
    CustomTabListKeys.kWhole,
    CustomTabListKeys.kMajor,
    CustomTabListKeys.kScholarship,
    CustomTabListKeys.kRecruitment,
    CustomTabListKeys.kLibrary,
    CustomTabListKeys.kInternational,
    CustomTabListKeys.kSWUniv,
  ];

  static const List<String> kAdditionalTabs = [
    CustomTabListKeys.kMajor2,
    CustomTabListKeys.kMajor3,
    CustomTabListKeys.kCollege,
    CustomTabListKeys.kGraduateSchool,
  ];

  /// **영문 탭 이름: 국문 탭 이름**
  static const Map<String, String> kTabMappingOnKey = {
    CustomTabListKeys.kWhole: CustomTabListKeys.WHOLE,
    CustomTabListKeys.kMajor: CustomTabListKeys.MAJOR,
    CustomTabListKeys.kMajor2: CustomTabListKeys.MAJOR2,
    CustomTabListKeys.kMajor3: CustomTabListKeys.MAJOR3,
    CustomTabListKeys.kScholarship: CustomTabListKeys.SCHOLARSHIP,
    CustomTabListKeys.kRecruitment: CustomTabListKeys.RECRUITMENT,
    CustomTabListKeys.kLibrary: CustomTabListKeys.LIBRARY,
    CustomTabListKeys.kInternational: CustomTabListKeys.INTERNATIONAL,
    CustomTabListKeys.kSWUniv: CustomTabListKeys.SWUNIV,
    CustomTabListKeys.kCollege: CustomTabListKeys.COLLEGE,
    CustomTabListKeys.kGraduateSchool: CustomTabListKeys.GRADUATESCHOOL,
  };

  static final Map<String, String> kTabMappingOnValue = Map.fromEntries(
      kTabMappingOnKey.entries
          .map((entry) => MapEntry(entry.value, entry.key)));

  static bool doesTabHaveSettingsPage(String tabName) {
    return tabName == CustomTabListKeys.kMajor ||
        tabName == CustomTabListKeys.kMajor2 ||
        tabName == CustomTabListKeys.kMajor3 ||
        tabName == CustomTabListKeys.kCollege ||
        tabName == CustomTabListKeys.kGraduateSchool;
  }

  /// **Preference 로드가 필요한지 판단**
  /// 필요한 경우: MAJOR, MAJOR2, MAJOR3,COLLEGE, GRADUATESCHOOL
  static bool isUserSettingType(String noticeType) {
    return noticeType == CustomTabListKeys.MAJOR ||
        noticeType == CustomTabListKeys.MAJOR2 ||
        noticeType == CustomTabListKeys.MAJOR3 ||
        noticeType == CustomTabListKeys.COLLEGE ||
        noticeType == CustomTabListKeys.GRADUATESCHOOL;
  }

  /// **학과 타입인지 판단**
  static bool isMajorType(String noticeType) {
    return noticeType == CustomTabListKeys.MAJOR ||
        noticeType == CustomTabListKeys.MAJOR2 ||
        noticeType == CustomTabListKeys.MAJOR3;
  }

  /// **유저 설정 값이 있는 경우, 유저 설정 값을 불러옴.**
  /// noticeType이 유저 설정 값이 없는 경우, null을 리턴
  static String? loadUserSettingKey(String noticeType) {
    String? userSettingKey;
    switch (noticeType) {
      // 학과
      case CustomTabListKeys.MAJOR:
        userSettingKey =
            SharedPrefsManager().getPreference(SharedPrefKeys.kMajorKey);
        break;
      case CustomTabListKeys.MAJOR2:
        userSettingKey =
            SharedPrefsManager().getPreference(SharedPrefKeys.kMajorKey2);
        break;
      case CustomTabListKeys.MAJOR3:
        userSettingKey =
            SharedPrefsManager().getPreference(SharedPrefKeys.kMajorKey3);
        break;
      // 단과대
      case CustomTabListKeys.COLLEGE:
        userSettingKey =
            SharedPrefsManager().getPreference(SharedPrefKeys.kCollegeKey);
        break;
      // 대학원
      case CustomTabListKeys.GRADUATESCHOOL:
        userSettingKey = SharedPrefsManager()
            .getPreference(SharedPrefKeys.kGraduateSchoolKey);
        break;
      default:
        break;
    }
    return userSettingKey;
  }
}
