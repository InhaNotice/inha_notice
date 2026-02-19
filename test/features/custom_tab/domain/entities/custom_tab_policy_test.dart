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
import 'package:inha_notice/features/custom_tab/domain/entities/custom_tab_policy.dart';

void main() {
  group('CustomTabPolicy 유닛 테스트', () {
    test('기본 탭 목록이 기존 정책과 동일하다', () {
      expect(CustomTabPolicy.kDefaultTabs, [
        '학사',
        '학과',
        '장학',
        '모집/채용',
        '정석',
        '국제처',
        'SW중심대학사업단',
      ]);
    });

    test('추가 탭 목록이 기존 정책과 동일하다', () {
      expect(CustomTabPolicy.kAdditionalTabs, [
        '학과2',
        '학과3',
        '단과대',
        '대학원',
        '기후위기대응사업단',
      ]);
    });
  });
}
