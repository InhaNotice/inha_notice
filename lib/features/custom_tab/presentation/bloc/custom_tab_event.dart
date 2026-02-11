/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-11
 */

import 'package:equatable/equatable.dart';

abstract class CustomTabEvent extends Equatable {
  const CustomTabEvent();

  @override
  List<Object> get props => [];
}

class LoadCustomTabEvent extends CustomTabEvent {
  const LoadCustomTabEvent();
}

class AddTabEvent extends CustomTabEvent {
  final String tab;

  const AddTabEvent({required this.tab});

  @override
  List<Object> get props => [tab];
}

class RemoveTabEvent extends CustomTabEvent {
  final int index;

  const RemoveTabEvent({required this.index});

  @override
  List<Object> get props => [index];
}

class ReorderTabsEvent extends CustomTabEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderTabsEvent({required this.oldIndex, required this.newIndex});

  @override
  List<Object> get props => [oldIndex, newIndex];
}

class SaveTabsEvent extends CustomTabEvent {
  const SaveTabsEvent();
}
