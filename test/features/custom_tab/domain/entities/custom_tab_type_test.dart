/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/features/custom_tab/domain/entities/custom_tab_type.dart';

void main() {
  group('CustomTabType 유닛 테스트', () {
    test('fromKey와 fromNoticeType이 올바르게 매핑된다', () {
      expect(CustomTabType.fromKey('학과'), CustomTabType.major);
      expect(
        CustomTabType.fromNoticeType('SCHOLARSHIP'),
        CustomTabType.scholarship,
      );
    });

    test('유저 설정 키 매핑이 올바르다', () {
      expect(CustomTabType.major.userSettingPrefKey, SharedPrefKeys.kMajorKey);
      expect(
          CustomTabType.college.userSettingPrefKey, SharedPrefKeys.kCollegeKey);
      expect(CustomTabType.whole.userSettingPrefKey, isNull);
    });

    test('hasSettingsPage/isMajorType 파생 규칙이 올바르다', () {
      expect(CustomTabType.major.hasSettingsPage, isTrue);
      expect(CustomTabType.major.isMajorType, isTrue);
      expect(CustomTabType.library.hasSettingsPage, isFalse);
      expect(CustomTabType.library.isMajorType, isFalse);
    });
  });
}
