/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-28
 */

import 'package:inha_notice/constants/university_keys/college_keys.dart';

abstract class CollegeUtils {
  /// 단과대 키들만 모아둔 컨테이너 (국문 명칭)
  static const List<String> kCollegeKeyList = <String>[
    CollegeKeys.kGeneralEDU,
    CollegeKeys.kENGCollege,
    CollegeKeys.kNSCollege,
    CollegeKeys.kCBA,
    CollegeKeys.kEDCollege,
    CollegeKeys.kSSCollege,
    CollegeKeys.kHACollege,
    CollegeKeys.kArtSports,
    CollegeKeys.kSWCC,
  ];

  /// 단과대 value들만 모아둔 컨테이너 (영문 키)
  static const List<String> kCollegeValueList = <String>[
    CollegeKeys.GENERALEDU,
    CollegeKeys.ENGCOLLEAGE,
    CollegeKeys.NSCOLLEAGE,
    CollegeKeys.CBA,
    CollegeKeys.EDCOLLEGE,
    CollegeKeys.SSCOLLEGE,
    CollegeKeys.HACOLLEGE,
    CollegeKeys.ARTSPORTS,
    CollegeKeys.SWCC,
  ];

  /// **키:값으로 매핑**
  static const Map<String, String> kCollegeMappingOnKey = {
    CollegeKeys.kGeneralEDU: CollegeKeys.GENERALEDU,
    CollegeKeys.kENGCollege: CollegeKeys.ENGCOLLEAGE,
    CollegeKeys.kNSCollege: CollegeKeys.NSCOLLEAGE,
    CollegeKeys.kCBA: CollegeKeys.CBA,
    CollegeKeys.kEDCollege: CollegeKeys.EDCOLLEGE,
    CollegeKeys.kSSCollege: CollegeKeys.SSCOLLEGE,
    CollegeKeys.kHACollege: CollegeKeys.HACOLLEGE,
    CollegeKeys.kArtSports: CollegeKeys.ARTSPORTS,
    CollegeKeys.kSWCC: CollegeKeys.SWCC,
  };

  /// **값:키로 매핑**
  static final Map<String, String> kCollegeMappingOnValue = Map.fromEntries(
      kCollegeMappingOnKey.entries
          .map((entry) => MapEntry(entry.value, entry.key)));
}
