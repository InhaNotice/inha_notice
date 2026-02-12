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
import 'package:inha_notice/features/university_setting/domain/entities/university_setting_type.dart';

abstract class UniversitySettingEvent extends Equatable {
  const UniversitySettingEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingEvent extends UniversitySettingEvent {
  final String prefKey;
  final UniversitySettingType settingType;
  final String? majorKeyType;

  const LoadSettingEvent({
    required this.prefKey,
    required this.settingType,
    this.majorKeyType,
  });

  @override
  List<Object?> get props => [prefKey, settingType, majorKeyType];
}

class FilterItemsEvent extends UniversitySettingEvent {
  final String query;

  const FilterItemsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class SelectItemEvent extends UniversitySettingEvent {
  final String itemName;

  const SelectItemEvent({required this.itemName});

  @override
  List<Object?> get props => [itemName];
}
