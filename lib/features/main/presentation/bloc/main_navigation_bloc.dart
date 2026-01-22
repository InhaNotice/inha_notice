/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-22
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/main_navigation/domain/usecases/get_initial_deep_link_usecase.dart';
import 'package:inha_notice/features/main_navigation/presentation/bloc/main_navigation_event.dart';
import 'package:inha_notice/features/main_navigation/presentation/bloc/main_navigation_state.dart';

class MainNavigationBloc
    extends Bloc<MainNavigationEvent, MainNavigationState> {
  final GetInitialDeepLinkUseCase getInitialDeepLinkUseCase;

  MainNavigationBloc({
    required this.getInitialDeepLinkUseCase,
  }) : super(const MainNavigationState()) {
    on<CheckInitialDeepLinkEvent>(_onCheckInitialDeepLink);
    on<ChangeMainTabEvent>(_onChangeMainTab);
  }

  Future<void> _onCheckInitialDeepLink(CheckInitialDeepLinkEvent event,
      Emitter<MainNavigationState> emit) async {
    final String? link = await getInitialDeepLinkUseCase();

    if (link != null) {
      emit(state.copyWith(initialUrl: link));
    }
  }

  Future<void> _onChangeMainTab(
      ChangeMainTabEvent event, Emitter<MainNavigationState> emit) async {
    emit(state.copyWith(tabIndex: event.index));
  }
}
