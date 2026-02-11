/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-11
 */

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/custom_tab/domain/entities/custom_tab_type.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_selected_tabs_use_case.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/save_tabs_use_case.dart';

import 'custom_tab_event.dart';
import 'custom_tab_state.dart';

class CustomTabBloc extends Bloc<CustomTabEvent, CustomTabState> {
  final GetSelectedTabsUseCase getSelectedTabsUseCase;
  final SaveTabsUseCase saveTabsUseCase;

  List<String> _initialTabs = [];

  CustomTabBloc({
    required this.getSelectedTabsUseCase,
    required this.saveTabsUseCase,
  }) : super(CustomTabInitial()) {
    on<LoadCustomTabEvent>(_onLoadTabs);
    on<AddTabEvent>(_onAddTab);
    on<RemoveTabEvent>(_onRemoveTab);
    on<ReorderTabsEvent>(_onReorderTabs);
    on<SaveTabsEvent>(_onSaveTabs);
  }

  Future<void> _onLoadTabs(
      LoadCustomTabEvent event, Emitter<CustomTabState> emit) async {
    emit(CustomTabLoading());
    final result = await getSelectedTabsUseCase();
    result.fold(
      (failure) => emit(CustomTabError(message: failure.message)),
      (tabs) {
        _initialTabs = List.from(tabs);
        emit(_buildLoadedState(tabs));
      },
    );
  }

  void _onAddTab(AddTabEvent event, Emitter<CustomTabState> emit) {
    if (state is! CustomTabLoaded) return;
    final current = state as CustomTabLoaded;
    if (current.selectedTabs.length >= 7) return;

    final newSelected = List<String>.from(current.selectedTabs)..add(event.tab);
    emit(_buildLoadedState(newSelected));
  }

  void _onRemoveTab(RemoveTabEvent event, Emitter<CustomTabState> emit) {
    if (state is! CustomTabLoaded) return;
    final current = state as CustomTabLoaded;
    if (current.selectedTabs.length <= 1) return;

    final newSelected = List<String>.from(current.selectedTabs)
      ..removeAt(event.index);
    emit(_buildLoadedState(newSelected));
  }

  void _onReorderTabs(ReorderTabsEvent event, Emitter<CustomTabState> emit) {
    if (state is! CustomTabLoaded) return;
    final current = state as CustomTabLoaded;

    final newSelected = List<String>.from(current.selectedTabs);
    int newIndex = event.newIndex;
    if (newIndex > event.oldIndex) newIndex -= 1;
    final item = newSelected.removeAt(event.oldIndex);
    newSelected.insert(newIndex, item);
    emit(_buildLoadedState(newSelected));
  }

  Future<void> _onSaveTabs(
      SaveTabsEvent event, Emitter<CustomTabState> emit) async {
    if (state is! CustomTabLoaded) return;
    final current = state as CustomTabLoaded;

    final result = await saveTabsUseCase(current.selectedTabs);
    result.fold(
      (failure) => emit(CustomTabError(message: failure.message)),
      (_) {
        _initialTabs = List.from(current.selectedTabs);
        emit(CustomTabSaved());
        emit(_buildLoadedState(current.selectedTabs));
      },
    );
  }

  CustomTabLoaded _buildLoadedState(List<String> selectedTabs) {
    final allTabs = {
      ...CustomTabType.kAdditionalTabs,
      ...CustomTabType.kDefaultTabs,
    }.toList();
    final availableTabs =
        allTabs.where((tab) => !selectedTabs.contains(tab)).toList();
    final hasChanges = !listEquals(selectedTabs, _initialTabs);

    return CustomTabLoaded(
      selectedTabs: selectedTabs,
      availableTabs: availableTabs,
      hasChanges: hasChanges,
    );
  }
}
