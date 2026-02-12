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

abstract class UniversitySettingState extends Equatable {
  const UniversitySettingState();

  @override
  List<Object?> get props => [];
}

class UniversitySettingInitial extends UniversitySettingState {}

class UniversitySettingLoading extends UniversitySettingState {}

class UniversitySettingLoaded extends UniversitySettingState {
  final UniversitySettingType settingType;
  final String? currentSettingName;
  final String? currentSettingKey;
  final String prefKey;
  final String? majorKeyType;

  /// flat list 아이템 (college, graduateSchool)
  final List<String> items;
  final List<String> filteredItems;

  /// grouped 아이템 (major)
  final Map<String, Map<String, String>> groups;
  final Map<String, Map<String, String>> filteredGroups;

  /// 검색 중 필터된 major 이름 목록
  final List<String> filteredMajors;

  final bool isProcessing;

  const UniversitySettingLoaded({
    required this.settingType,
    required this.currentSettingName,
    required this.currentSettingKey,
    required this.prefKey,
    this.majorKeyType,
    this.items = const [],
    this.filteredItems = const [],
    this.groups = const {},
    this.filteredGroups = const {},
    this.filteredMajors = const [],
    this.isProcessing = false,
  });

  UniversitySettingLoaded copyWith({
    String? currentSettingName,
    String? currentSettingKey,
    List<String>? items,
    List<String>? filteredItems,
    Map<String, Map<String, String>>? groups,
    Map<String, Map<String, String>>? filteredGroups,
    List<String>? filteredMajors,
    bool? isProcessing,
  }) {
    return UniversitySettingLoaded(
      settingType: settingType,
      currentSettingName: currentSettingName ?? this.currentSettingName,
      currentSettingKey: currentSettingKey ?? this.currentSettingKey,
      prefKey: prefKey,
      majorKeyType: majorKeyType,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      groups: groups ?? this.groups,
      filteredGroups: filteredGroups ?? this.filteredGroups,
      filteredMajors: filteredMajors ?? this.filteredMajors,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }

  @override
  List<Object?> get props => [
        settingType,
        currentSettingName,
        currentSettingKey,
        prefKey,
        majorKeyType,
        items,
        filteredItems,
        groups,
        filteredGroups,
        filteredMajors,
        isProcessing,
      ];
}

class UniversitySettingSaved extends UniversitySettingState {
  final String message;

  const UniversitySettingSaved({required this.message});

  @override
  List<Object?> get props => [message];
}

class UniversitySettingError extends UniversitySettingState {
  final String message;

  const UniversitySettingError({required this.message});

  @override
  List<Object?> get props => [message];
}
