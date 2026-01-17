/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/notice/domain/entities/home_tab_entity.dart';
import 'package:inha_notice/features/notice/domain/failures/home_failure.dart';
import 'package:inha_notice/features/notice/domain/usecases/get_home_tabs_usecase.dart';
import 'package:inha_notice/features/notice/presentation/bloc/home_event.dart';
import 'package:inha_notice/features/notice/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeTabsUseCase getHomeTabsUsecase;

  HomeBloc({required this.getHomeTabsUsecase}) : super(HomeInitial()) {
    on<LoadHomeTabsEvent>(_onHomeTabsRequested);
  }

  Future<void> _onHomeTabsRequested(
      LoadHomeTabsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    final Either<HomeFailure, List<HomeTabEntity>> results =
        await getHomeTabsUsecase();

    results.fold(
      (failure) {
        final String errorMessage = failure.when(tabs: (msg) => msg);
        emit(HomeError(message: errorMessage));
      },
      (tabs) {
        emit(HomeLoaded(tabs: tabs));
      },
    );
  }
}
