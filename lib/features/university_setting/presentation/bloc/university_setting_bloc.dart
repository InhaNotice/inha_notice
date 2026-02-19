/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_major_display_name_use_case.dart';
import 'package:inha_notice/features/notice/domain/entities/college_type.dart';
import 'package:inha_notice/features/notice/domain/entities/graduate_school_type.dart';
import 'package:inha_notice/features/notice/domain/entities/major_type.dart';
import 'package:inha_notice/features/university_setting/domain/entities/university_setting_type.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/get_current_setting_use_case.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/save_major_setting_use_case.dart';
import 'package:inha_notice/features/university_setting/domain/usecases/save_setting_use_case.dart';

import 'university_setting_event.dart';
import 'university_setting_state.dart';

class UniversitySettingBloc
    extends Bloc<UniversitySettingEvent, UniversitySettingState> {
  final GetCurrentSettingUseCase getCurrentSettingUseCase;
  final SaveSettingUseCase saveSettingUseCase;
  final SaveMajorSettingUseCase saveMajorSettingUseCase;
  final GetMajorDisplayNameUseCase getMajorDisplayNameUseCase;

  UniversitySettingBloc({
    required this.getCurrentSettingUseCase,
    required this.saveSettingUseCase,
    required this.saveMajorSettingUseCase,
    required this.getMajorDisplayNameUseCase,
  }) : super(UniversitySettingInitial()) {
    on<LoadSettingEvent>(_onLoadSetting);
    on<FilterItemsEvent>(_onFilterItems);
    on<SelectItemEvent>(_onSelectItem);
  }

  Future<void> _onLoadSetting(
      LoadSettingEvent event, Emitter<UniversitySettingState> emit) async {
    emit(UniversitySettingLoading());

    final result = await getCurrentSettingUseCase(prefKey: event.prefKey);

    result.fold(
      (failure) => emit(UniversitySettingError(message: failure.message)),
      (savedKey) {
        switch (event.settingType) {
          case UniversitySettingType.major:
            _emitMajorLoaded(emit, savedKey, event.prefKey, event.majorKeyType);
          case UniversitySettingType.college:
            _emitCollegeLoaded(emit, savedKey, event.prefKey);
          case UniversitySettingType.graduateSchool:
            _emitGraduateSchoolLoaded(emit, savedKey, event.prefKey);
        }
      },
    );
  }

  void _emitMajorLoaded(Emitter<UniversitySettingState> emit, String? savedKey,
      String prefKey, String? majorKeyType) {
    String? displayName;
    if (savedKey != null) {
      displayName = getMajorDisplayNameUseCase(savedKey);
    }
    final groups = MajorType.majorGroups;
    emit(UniversitySettingLoaded(
      settingType: UniversitySettingType.major,
      currentSettingName: displayName,
      currentSettingKey: savedKey,
      prefKey: prefKey,
      majorKeyType: majorKeyType,
      groups: groups,
      filteredGroups: groups,
    ));
  }

  void _emitCollegeLoaded(
      Emitter<UniversitySettingState> emit, String? savedKey, String prefKey) {
    String? displayName;
    if (savedKey != null) {
      displayName = CollegeType.getByKey(savedKey).name;
    }
    final items = CollegeType.names;
    emit(UniversitySettingLoaded(
      settingType: UniversitySettingType.college,
      currentSettingName: displayName,
      currentSettingKey: savedKey,
      prefKey: prefKey,
      items: items,
      filteredItems: items,
    ));
  }

  void _emitGraduateSchoolLoaded(
      Emitter<UniversitySettingState> emit, String? savedKey, String prefKey) {
    String? displayName;
    if (savedKey != null) {
      displayName = GraduateSchoolType.graduateSchoolMappingOnKey[savedKey];
    }
    final items = GraduateSchoolType.graduateSchoolNameList;
    emit(UniversitySettingLoaded(
      settingType: UniversitySettingType.graduateSchool,
      currentSettingName: displayName,
      currentSettingKey: savedKey,
      prefKey: prefKey,
      items: items,
      filteredItems: items,
    ));
  }

  void _onFilterItems(
      FilterItemsEvent event, Emitter<UniversitySettingState> emit) {
    if (state is! UniversitySettingLoaded) return;
    final current = state as UniversitySettingLoaded;

    if (current.settingType == UniversitySettingType.major) {
      _filterMajorItems(emit, current, event.query);
    } else {
      _filterFlatItems(emit, current, event.query);
    }
  }

  void _filterMajorItems(Emitter<UniversitySettingState> emit,
      UniversitySettingLoaded current, String query) {
    if (query.isEmpty) {
      emit(current.copyWith(
        filteredGroups: current.groups,
        filteredMajors: [],
      ));
      return;
    }
    final List<String> filtered = [
      for (var group in current.groups.values)
        for (var major in group.keys)
          if (major.contains(query)) major,
    ];
    emit(current.copyWith(
      filteredGroups: {},
      filteredMajors: filtered,
    ));
  }

  void _filterFlatItems(Emitter<UniversitySettingState> emit,
      UniversitySettingLoaded current, String query) {
    if (query.isEmpty) {
      emit(current.copyWith(filteredItems: current.items));
      return;
    }
    final filtered =
        current.items.where((item) => item.contains(query)).toList();
    emit(current.copyWith(filteredItems: filtered));
  }

  Future<void> _onSelectItem(
      SelectItemEvent event, Emitter<UniversitySettingState> emit) async {
    if (state is! UniversitySettingLoaded) return;
    final current = state as UniversitySettingLoaded;

    switch (current.settingType) {
      case UniversitySettingType.major:
        await _selectMajor(emit, current, event.itemName);
      case UniversitySettingType.college:
        await _selectCollege(emit, current, event.itemName);
      case UniversitySettingType.graduateSchool:
        await _selectGraduateSchool(emit, current, event.itemName);
    }
  }

  Future<void> _selectMajor(Emitter<UniversitySettingState> emit,
      UniversitySettingLoaded current, String itemName) async {
    final String? newKey = MajorType.majorMappingOnKey[itemName];
    if (current.currentSettingKey == newKey) {
      emit(const UniversitySettingError(message: 'already_set'));
      emit(current);
      return;
    }

    emit(current.copyWith(isProcessing: true));

    final result = await saveMajorSettingUseCase(
      oldKey: current.currentSettingKey,
      newKey: newKey!,
      majorKeyType: current.majorKeyType!,
    );

    result.fold(
      (failure) {
        emit(const UniversitySettingError(message: 'save_error'));
        emit(current.copyWith(isProcessing: false));
      },
      (_) => emit(UniversitySettingSaved(message: itemName)),
    );
  }

  Future<void> _selectCollege(Emitter<UniversitySettingState> emit,
      UniversitySettingLoaded current, String itemName) async {
    final String newKey = CollegeType.getByName(itemName).key;
    if (current.currentSettingKey == newKey) {
      emit(const UniversitySettingError(message: 'already_set'));
      emit(current);
      return;
    }

    emit(current.copyWith(isProcessing: true));

    final result =
        await saveSettingUseCase(prefKey: current.prefKey, value: newKey);

    result.fold(
      (failure) {
        emit(const UniversitySettingError(message: 'save_error'));
        emit(current.copyWith(isProcessing: false));
      },
      (_) => emit(UniversitySettingSaved(message: itemName)),
    );
  }

  Future<void> _selectGraduateSchool(Emitter<UniversitySettingState> emit,
      UniversitySettingLoaded current, String itemName) async {
    final String? newKey =
        GraduateSchoolType.graduateSchoolMappingOnName[itemName];
    if (current.currentSettingKey == newKey) {
      emit(const UniversitySettingError(message: 'already_set'));
      emit(current);
      return;
    }

    emit(current.copyWith(isProcessing: true));

    final result =
        await saveSettingUseCase(prefKey: current.prefKey, value: newKey!);

    result.fold(
      (failure) {
        emit(const UniversitySettingError(message: 'save_error'));
        emit(current.copyWith(isProcessing: false));
      },
      (_) => emit(UniversitySettingSaved(message: itemName)),
    );
  }
}
