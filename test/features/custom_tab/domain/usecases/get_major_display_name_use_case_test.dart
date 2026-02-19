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
import 'package:inha_notice/features/custom_tab/domain/usecases/get_major_display_name_use_case.dart';

void main() {
  group('GetMajorDisplayNameUseCase 유닛 테스트', () {
    test('지원 학과 키면 학과명을 반환한다', () {
      final useCase = GetMajorDisplayNameUseCase();

      final result = useCase('CSE');

      expect(result, '컴퓨터공학과');
    });

    test('미지원 학과 키면 fallback 학과명 또는 기본 문구를 반환한다', () {
      final useCase = GetMajorDisplayNameUseCase();

      final result = useCase('UNKNOWN_MAJOR_KEY');

      expect(result, isNotEmpty);
    });
  });
}
