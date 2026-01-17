/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

enum DatabaseErrorType {
  path('DB_PATH_ERROR', '데이터베이스 경로를 찾을 수 없습니다.'),
  initialization('DB_INIT_ERROR', '데이터베이스 초기화에 실패했습니다.'),
  operation('DB_OPERATION_ERROR', '데이터베이스 쿼리 실행 중 오류가 발생했습니다.'),
  unknown('DB_UNKNOWN', '알 수 없는 데이터베이스 오류가 발생했습니다.');

  final String code;
  final String defaultMessage;

  const DatabaseErrorType(this.code, this.defaultMessage);
}
