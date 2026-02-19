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
import 'package:inha_notice/core/error/exceptions.dart';

void main() {
  group('Exception 유닛 테스트', () {
    test('LocalDatabaseException은 error가 없으면 메시지만 출력한다', () {
      final exception = LocalDatabaseException('db 오류');

      expect(exception.toString(), 'LocalDatabaseException: db 오류');
    });

    test('LocalDatabaseException은 error가 있으면 함께 출력한다', () {
      final exception = LocalDatabaseException('db 오류', 'E001');

      expect(exception.toString(), 'LocalDatabaseException: db 오류 (E001)');
    });

    test('ServerException은 error가 없으면 메시지만 출력한다', () {
      final exception = ServerException('server 오류');

      expect(exception.toString(), 'ServerException: server 오류');
    });

    test('ServerException은 error가 있으면 함께 출력한다', () {
      final exception = ServerException('server 오류', 500);

      expect(exception.toString(), 'ServerException: server 오류 (500)');
    });
  });
}
