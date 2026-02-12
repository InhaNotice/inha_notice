/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

class LocalDatabaseException implements Exception {
  final String message;
  final Object? error;

  LocalDatabaseException(this.message, [this.error]);

  @override
  String toString() {
    if (error != null) return 'LocalDatabaseException: $message ($error)';
    return 'LocalDatabaseException: $message';
  }
}

class ServerException implements Exception {
  final String message;
  final Object? error;

  ServerException(this.message, [this.error]);

  @override
  String toString() {
    if (error != null) return 'ServerException: $message ($error)';
    return 'ServerException: $message';
  }
}
