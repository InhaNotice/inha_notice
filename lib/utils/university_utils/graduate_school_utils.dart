/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-23
 */

import 'package:inha_notice/core/keys/graduate_school_keys.dart';

abstract class GraduateSchoolUtils {
  /// 대학원 키들만 모아둔 컨테이너 (국문 명칭)
  static const List<String> kGraduateSchoolKeyList = <String>[
    GraduateSchoolKeys.kGRAD,
    GraduateSchoolKeys.kENGRAD,
    GraduateSchoolKeys.kMBA,
    GraduateSchoolKeys.kEDUGRAD,
    GraduateSchoolKeys.kADMGRAD,
    GraduateSchoolKeys.kCOUNSELGRAD,
    GraduateSchoolKeys.kGSPH,
    GraduateSchoolKeys.kILS,
    GraduateSchoolKeys.kGSL,
    GraduateSchoolKeys.kIMIS,
  ];

  /// 대학원 value들만 모아둔 컨테이너 (영문 키)
  static const List<String> kGraduateSchoolValueList = <String>[
    GraduateSchoolKeys.GRAD,
    GraduateSchoolKeys.ENGRAD,
    GraduateSchoolKeys.MBA,
    GraduateSchoolKeys.EDUGRAD,
    GraduateSchoolKeys.ADMGRAD,
    GraduateSchoolKeys.COUNSELGRAD,
    GraduateSchoolKeys.GSPH,
    GraduateSchoolKeys.ILS,
    GraduateSchoolKeys.GSL,
    GraduateSchoolKeys.IMIS,
  ];

  /// **키:값으로 매핑**
  static const Map<String, String> kGraduateSchoolMappingOnKey = {
    GraduateSchoolKeys.kGRAD: GraduateSchoolKeys.GRAD,
    GraduateSchoolKeys.kENGRAD: GraduateSchoolKeys.ENGRAD,
    GraduateSchoolKeys.kMBA: GraduateSchoolKeys.MBA,
    GraduateSchoolKeys.kEDUGRAD: GraduateSchoolKeys.EDUGRAD,
    GraduateSchoolKeys.kADMGRAD: GraduateSchoolKeys.ADMGRAD,
    GraduateSchoolKeys.kCOUNSELGRAD: GraduateSchoolKeys.COUNSELGRAD,
    GraduateSchoolKeys.kGSPH: GraduateSchoolKeys.GSPH,
    GraduateSchoolKeys.kILS: GraduateSchoolKeys.ILS,
    GraduateSchoolKeys.kGSL: GraduateSchoolKeys.GSL,
    GraduateSchoolKeys.kIMIS: GraduateSchoolKeys.IMIS,
  };

  /// **값:키로 매핑**
  static final Map<String, String> kGraduateSchoolMappingOnValue =
      Map.fromEntries(kGraduateSchoolMappingOnKey.entries
          .map((entry) => MapEntry(entry.value, entry.key)));
}
