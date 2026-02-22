/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

/// **SharedPrefsKeys**
/// SharedPrefsManager에서 사용되는 키를 저장하는 클래스입니다.
abstract class SharedPrefKeys {
  static const String kUserThemeSetting = 'user-theme-setting';
  static const String kCacheCapacity = 'cache-capacity';
  static const String kSubscribedTopics = 'subscribed_topics';
  static const String kCustomTabList = 'custom-tab-list';
  static const String kIsSubscribedToAllUsers = 'isSubscribedToAllUsers';
  static const String kAllUsers = 'all-users';
  static const String kAllNotices = 'all-notices';
  static const String kPreviousMajorKey = 'previous-major-key';
  static const String kMajorKey = 'major-key';
  static const String kMajorKey2 = 'major-key-2';
  static const String kMajorKey3 = 'major-key-3';
  static const String kCollegeKey = 'college-key';
  static const String kGraduateSchoolKey = 'graduate-school-key';
  static const String kAcademicNotification = 'academic-notification';
  static const String kScholarship = 'SCHOLARSHIP';
  static const String kRecruitment = 'RECRUITMENT';
  static const String kMajorNotification = 'major-notification';
  static const String INTERNATIONAL = 'INTERNATIONAL';
  static const String SWUNIV = 'SWUNIV';
  static const String INHAHUSS = 'INHAHUSS';

  // 학사일정 하루 전(D-1) 알림
  static const String kUndergraduateScheduleD1Notification =
      'undergraduate-schedule-d1-notification';

  // 학사일정 당일(D-Day) 알림
  static const String kUndergraduateScheduleDDNotification =
      'undergraduate-schedule-dd-notification';

  // 정석학술정보관
  static const String kLibrary = 'LIBRARY';

  // 기본 정렬 설정
  static const String kNoticeBoardDefaultType = 'notice-board-default-type';
  static const String kBookmarkDefaultSort = 'bookmark-default-sort';
  static const String kSearchResultDefaultSort = 'search-result-default-sort';
}
