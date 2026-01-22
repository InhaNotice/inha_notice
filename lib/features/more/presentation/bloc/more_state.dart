/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-22
 */

import 'package:equatable/equatable.dart';

import '../../domain/entities/more_configuration_entity.dart';

abstract class MoreState extends Equatable {
  const MoreState();

  @override
  List<Object?> get props => [];
}

class MoreInitial extends MoreState {}

class MoreLoading extends MoreState {}

class MoreLoaded extends MoreState {
  final MoreConfigurationEntity webUrls;

  const MoreLoaded({required this.webUrls});

  @override
  List<Object?> get props => [webUrls];
}

class MoreError extends MoreState {
  final String message;

  const MoreError({required this.message});

  @override
  List<Object?> get props => [message];
}
