/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

enum UniversitySettingType {
  major(
    appBarTitle: '학과 설정',
    searchLabel: '학과 검색',
    settingTypeName: '학과',
  ),
  college(
    appBarTitle: '단과대 설정',
    searchLabel: '단과대 검색',
    settingTypeName: '단과대',
  ),
  graduateSchool(
    appBarTitle: '대학원 설정',
    searchLabel: '대학원 검색',
    settingTypeName: '대학원',
  );

  final String appBarTitle;
  final String searchLabel;
  final String settingTypeName;

  const UniversitySettingType({
    required this.appBarTitle,
    required this.searchLabel,
    required this.settingTypeName,
  });
}
