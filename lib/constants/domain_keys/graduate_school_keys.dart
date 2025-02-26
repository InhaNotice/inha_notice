/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-25
 */

abstract class GraduateSchoolKeys {
  // 대학원 (10)
  static const String GRAD = 'GRAD';
  static const String ENGRAD = 'ENGRAD';
  static const String MBA = 'MBA';
  static const String EDUGRAD = 'EDUGRAD';
  static const String ADMGRAD = 'ADMGRAD';
  static const String COUNSELGRAD = 'COUNSELGRAD';
  static const String GSPH = 'GSPH';
  static const String ILS = 'ILS';
  static const String GSL = 'GSL';
  static const String IMIS = 'IMIS';

  static const Map<String, String> graduateSchoolGroups = {
    '일반대학원': GRAD,
    '공학대학원': ENGRAD,
    '경영대학원': MBA,
    '교육대학원': EDUGRAD,
    '정책대학원': ADMGRAD,
    '상담심리대학원': COUNSELGRAD,
    '보건대학원': GSPH,
    '법학전문대학원': ILS,
    '물류전문대학원': GSL,
    '제조혁신전문대학원': IMIS,
  };
}
