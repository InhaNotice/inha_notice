/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-25
 */

abstract class CollegeKeys {
  // 단과대 (9)
  static const String GENERALEDU = 'GENERALEDU';
  static const String ENGCOLLEAGE = 'ENGCOLLEAGE';
  static const String NSCOLLEAGE = 'NSCOLLEAGE';
  static const String CBA = 'CBA';
  static const String EDCOLLEGE = 'EDCOLLEGE';
  static const String SSCOLLEGE = 'SSCOLLEGE';
  static const String HACOLLEGE = 'HACOLLEGE';
  static const String ARTSPORTS = 'ARTSPORTS';
  static const String SWCC = 'SWCC';

  static const Map<String, String> collegeGroups = {
    '프런티어창의대학': GENERALEDU,
    '공과대학': ENGCOLLEAGE,
    '자연과학대학': NSCOLLEAGE,
    '경영대학': CBA,
    '사범대학': EDCOLLEGE,
    '사회과학대학': SSCOLLEGE,
    '문과대학': HACOLLEGE,
    '예술체육대학': ARTSPORTS,
    '소프트웨어융합대학': SWCC,
  };
}
