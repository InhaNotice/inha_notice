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

abstract class MainNavigationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckInitialDeepLinkEvent extends MainNavigationEvent {}

class ChangeMainTabEvent extends MainNavigationEvent {
  final int index;

  ChangeMainTabEvent(this.index);

  @override
  List<Object?> get props => [index];
}
