import 'package:inha_notice/constants/custom_tab_list/custom_tab_list_keys.dart';

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
    CustomTabListKeys.kCollege,
    CustomTabListKeys.kGraduateSchool,
  ];

  static const Map<String, String> kTabGroups = {
    CustomTabListKeys.kWhole: CustomTabListKeys.WHOLE,
    CustomTabListKeys.kMajor: CustomTabListKeys.MAJOR,
    CustomTabListKeys.kScholarship: CustomTabListKeys.SCHOLARSHIP,
    CustomTabListKeys.kRecruitment: CustomTabListKeys.RECRUITMENT,
    CustomTabListKeys.kLibrary: CustomTabListKeys.LIBRARY,
    CustomTabListKeys.kInternational: CustomTabListKeys.INTERNATIONAL,
    CustomTabListKeys.kSWUniv: CustomTabListKeys.SWUNIV,
    CustomTabListKeys.kCollege: CustomTabListKeys.COLLEGE,
    CustomTabListKeys.kGraduateSchool: CustomTabListKeys.GRADUATESCHOOL,
  };

  static bool doesTabHaveSettingsPage(String tabName) {
    return tabName == CustomTabListKeys.kMajor ||
        tabName == CustomTabListKeys.kCollege ||
        tabName == CustomTabListKeys.kGraduateSchool;
  }

  static bool requiresUserSetting(String noticeType) {
    return noticeType == CustomTabListKeys.MAJOR ||
        noticeType == CustomTabListKeys.COLLEGE ||
        noticeType == CustomTabListKeys.GRADUATESCHOOL;
  }

  static String? convertNoticeTypeToKorean(String noticeType) {
    switch (noticeType) {
      case CustomTabListKeys.MAJOR:
        return CustomTabListKeys.kMajor;
      case CustomTabListKeys.COLLEGE:
        return CustomTabListKeys.kCollege;
      case CustomTabListKeys.GRADUATESCHOOL:
        return CustomTabListKeys.kGraduateSchool;
      default:
        return null;
    }
  }
}
