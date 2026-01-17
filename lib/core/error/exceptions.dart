/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'package:equatable/equatable.dart';

import 'error_types.dart';

class LocalDatabaseException extends Equatable implements Exception {
  final DatabaseErrorType type;
  final String message;
  final Object? error;

  LocalDatabaseException({required this.type, String? message, this.error})
      : message = message ?? type.defaultMessage;

  @override
  List<Object?> get props => [type, message, error];

  @override
  bool? get stringify => true;

  @override
  String toString() {
    if (error != null) {
      return 'LocalDatabaseException: $message (Code: ${type.code}, Cause: $error)';
    }
    return 'LocalDatabaseException: $message (Code: ${type.code})';
  }
}
