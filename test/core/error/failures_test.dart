/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-18
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/error/failures.dart';

class _TestFailure extends Failures {
  const _TestFailure(super.message);
}

void main() {
  group('Failures 유닛 테스트', () {
    test('같은 message를 가지면 동등 비교가 true다', () {
      const first = _TestFailure('오류');
      const second = _TestFailure('오류');

      expect(first, second);
      expect(first.props, ['오류']);
    });

    test('message가 다르면 동등 비교가 false다', () {
      const first = _TestFailure('오류1');
      const second = _TestFailure('오류2');

      expect(first == second, isFalse);
    });
  });
}
