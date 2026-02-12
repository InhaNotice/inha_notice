/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:equatable/equatable.dart';

abstract class CustomTabState extends Equatable {
  const CustomTabState();

  @override
  List<Object?> get props => [];
}

class CustomTabInitial extends CustomTabState {}

class CustomTabLoading extends CustomTabState {}

class CustomTabLoaded extends CustomTabState {
  final List<String> selectedTabs;
  final List<String> availableTabs;
  final bool hasChanges;

  const CustomTabLoaded({
    required this.selectedTabs,
    required this.availableTabs,
    required this.hasChanges,
  });

  @override
  List<Object?> get props => [selectedTabs, availableTabs, hasChanges];
}

class CustomTabSaved extends CustomTabState {}

class CustomTabError extends CustomTabState {
  final String message;

  const CustomTabError({required this.message});

  @override
  List<Object?> get props => [message];
}
