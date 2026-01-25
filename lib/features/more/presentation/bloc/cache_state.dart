/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-25
 */

import 'package:equatable/equatable.dart';

abstract class CacheState extends Equatable {
  const CacheState();

  @override
  List<Object?> get props => [];
}

class CacheInitial extends CacheState {}

class CacheLoading extends CacheState {}

class CacheLoaded extends CacheState {
  final String cacheSize;

  const CacheLoaded({required this.cacheSize});

  @override
  List<Object?> get props => [cacheSize];
}

class CacheError extends CacheState {
  final String message;

  const CacheError({required this.message});

  @override
  List<Object?> get props => [message];
}
