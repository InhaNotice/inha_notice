/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/search/domain/failures/search_result_failure.dart';
import 'package:inha_notice/features/search/domain/usecases/search_notices_use_case.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_result_event.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_result_state.dart';

class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  final SearchNoticesUseCase searchNoticesUseCase;

  SearchResultBloc({
    required this.searchNoticesUseCase,
  }) : super(SearchResultInitial()) {
    on<SearchNoticesRequestedEvent>(_onSearchRequested);
    on<SearchPageChangedEvent>(_onPageChanged);
    on<SearchSortChangedEvent>(_onSortChanged);
  }

  Future<void> _onSearchRequested(
    SearchNoticesRequestedEvent event,
    Emitter<SearchResultState> emit,
  ) async {
    emit(SearchResultLoading());

    final result = await searchNoticesUseCase(
      query: event.query,
      startCount: event.startCount,
      sortType: event.sortType,
    );

    result.fold(
      (failure) {
        final errorMessage = failure.when(
          network: (msg) => msg,
          unknown: (msg) => msg,
        );
        emit(SearchResultError(message: errorMessage));
      },
      (searchResult) => emit(
        SearchResultLoaded(
          notices: searchResult.notices,
          pages: searchResult.pages,
          query: event.query,
          currentPage: event.startCount,
          sortType: event.sortType,
        ),
      ),
    );
  }

  Future<void> _onPageChanged(
    SearchPageChangedEvent event,
    Emitter<SearchResultState> emit,
  ) async {
    if (state is! SearchResultLoaded) return;

    final currentState = state as SearchResultLoaded;

    emit(SearchResultLoading());

    final result = await searchNoticesUseCase(
      query: currentState.query,
      startCount: event.startCount,
      sortType: currentState.sortType,
    );

    result.fold(
      (failure) {
        final errorMessage = failure.when(
          network: (msg) => msg,
          unknown: (msg) => msg,
        );
        emit(SearchResultError(message: errorMessage));
      },
      (searchResult) => emit(
        SearchResultLoaded(
          notices: searchResult.notices,
          pages: searchResult.pages,
          query: currentState.query,
          currentPage: event.startCount,
          sortType: currentState.sortType,
        ),
      ),
    );
  }

  Future<void> _onSortChanged(
    SearchSortChangedEvent event,
    Emitter<SearchResultState> emit,
  ) async {
    if (state is! SearchResultLoaded) return;

    final currentState = state as SearchResultLoaded;

    emit(SearchResultLoading());

    final result = await searchNoticesUseCase(
      query: currentState.query,
      startCount: 0, // 정렬 변경 시 첫 페이지로
      sortType: event.sortType,
    );

    result.fold(
      (failure) {
        final errorMessage = failure.when(
          network: (msg) => msg,
          unknown: (msg) => msg,
        );
        emit(SearchResultError(message: errorMessage));
      },
      (searchResult) => emit(
        SearchResultLoaded(
          notices: searchResult.notices,
          pages: searchResult.pages,
          query: currentState.query,
          currentPage: 0,
          sortType: event.sortType,
        ),
      ),
    );
  }
}
