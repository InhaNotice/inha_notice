/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-19
 */

/// 대학원 목록 (키, 국문명)
enum GraduateSchoolType {
  // 10개
  general(key: 'GRAD', name: '일반대학원'),
  engineering(key: 'ENGRAD', name: '공학대학원'),
  business(key: 'MBA', name: '경영대학원'),
  education(key: 'EDUGRAD', name: '교육대학원'),
  policy(key: 'ADMGRAD', name: '정책대학원'),
  counselingPsychology(key: 'COUNSELGRAD', name: '상담심리대학원'),
  publicHealth(key: 'GSPH', name: '보건대학원'),
  law(key: 'ILS', name: '법학전문대학원'),
  logistics(key: 'GSL', name: '물류전문대학원'),
  manufacturingInnovation(key: 'IMIS', name: '제조혁신전문대학원');

  final String key;
  final String name;

  const GraduateSchoolType({
    required this.key,
    required this.name,
  });

  /// 대학원 국문 명칭 리스트
  /// 예: ['일반대학원', '공학대학원', ...]
  static List<String> get graduateSchoolNameList =>
      GraduateSchoolType.values.map((e) => e.name).toList(growable: false);

  /// 대학원 영문 키 리스트
  /// 예: ['GRAD', 'ENGRAD', ...]
  static List<String> get graduateSchoolKeyList =>
      GraduateSchoolType.values.map((e) => e.key).toList(growable: false);

  /// 국문 명칭 -> 영문 키 매핑
  /// 예: {'일반대학원': 'GRAD', ...}
  static Map<String, String> get graduateSchoolMappingOnName =>
      {for (var e in GraduateSchoolType.values) e.name: e.key};

  /// 영문 키 -> 국문 명칭 매핑
  /// 예: {'GRAD': '일반대학원', ...}
  static Map<String, String> get graduateSchoolMappingOnKey =>
      {for (var e in GraduateSchoolType.values) e.key: e.name};

  /// 코드로 GraduateSchoolType 찾기
  static GraduateSchoolType? getByKey(String key) {
    try {
      return GraduateSchoolType.values.firstWhere((e) => e.key == key);
    } catch (_) {
      return null;
    }
  }
}
