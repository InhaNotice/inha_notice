/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:inha_notice/features/notice/domain/entities/major_type.dart';

class GetMajorDisplayNameUseCase {
  String call(String majorKey) {
    final String? activeMajorName = MajorType.majorMappingOnValue[majorKey];
    if (activeMajorName != null) {
      return activeMajorName;
    }

    return MajorType.getUnsupportedMajorKoreanName(majorKey) ?? '미지원 학과';
  }
}
