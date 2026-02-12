/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

enum CollegeType {
  generalEDU(key: 'GENERALEDU', name: '프런티어창의대학'),

  // 경고: engCollege와 nsCollege의 키 값은 오타로 저장되어 있음. 수정 금지.
  engCollege(key: 'ENGCOLLEAGE', name: '공과대학'),
  nsCollege(key: 'NSCOLLEAGE', name: '자연과학대학'),

  cba(key: 'CBA', name: '경영대학'),
  edCollege(key: 'EDCOLLEGE', name: '사범대학'),
  ssCollege(key: 'SSCOLLEGE', name: '사회과학대학'),
  haCollege(key: 'HACOLLEGE', name: '문과대학'),
  artSports(key: 'ARTSPORTS', name: '예술체육대학'),
  swcc(key: 'SWCC', name: '소프트웨어융합대학');

  final String key;
  final String name;

  const CollegeType({
    required this.key,
    required this.name,
  });

  /// 영문 키 리스트
  static List<String> get keys => values.map((e) => e.key).toList();

  /// 국문 키 리스트
  static List<String> get names => values.map((e) => e.name).toList();

  static CollegeType getByKey(String key) {
    return CollegeType.values.firstWhere(
      (e) => e.key == key,
      orElse: () => CollegeType.generalEDU,
    );
  }

  static CollegeType getByName(String name) {
    return CollegeType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => CollegeType.generalEDU,
    );
  }
}
