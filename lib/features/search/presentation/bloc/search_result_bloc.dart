/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-23
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/constants/page_constants.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/features/notice/data/datasources/read_notice_local_data_source.dart';
import 'package:inha_notice/features/search/domain/entities/search_result_entity.dart';
import 'package:inha_notice/features/search/domain/failures/search_failure.dart';
import 'package:inha_notice/features/search/domain/usecases/get_search_results_use_case.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_result_event.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_result_state.dart';
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/usecases/get_user_preference_use_case.dart';

class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  final GetSearchResultsUseCase getSearchResultsUseCase;
  final GetUserPreferenceUseCase getUserPreferencesUseCase;

  late String _query;
  SearchResultDefaultSortType _sortType = SearchResultDefaultSortType.date;
  Pages _currentPages = createPages();

  SearchResultBloc({
    required this.getSearchResultsUseCase,
    required this.getUserPreferencesUseCase,
  }) : super(SearchResultInitial()) {
    on<LoadSearchResultEvent>(_onLoadSearchResult);
    on<ChangeSortTypeEvent>(_onChangeSortType);
    on<LoadPageEvent>(_onLoadPage);
    on<RefreshSearchResultEvent>(_onRefreshSearchResult);
    on<MarkNoticeAsReadEvent>(_onMarkNoticeAsRead);
  }

  Future<void> _onLoadSearchResult(
      LoadSearchResultEvent event, Emitter<SearchResultState> emit) async {
    _query = event.query;

    // UserPreference에서 기본 sortType 조회
    _sortType = getUserPreferencesUseCase().fold(
      (_) => SearchResultDefaultSortType.date,
      (preferences) => preferences.searchResultDefaultSort,
    );

    _currentPages = createPages();
    emit(SearchResultLoading());
    await _fetchSearchResults(
        emit, PageConstants.kInitialRelativePage, true);
  }

  Future<void> _onChangeSortType(
      ChangeSortTypeEvent event, Emitter<SearchResultState> emit) async {
    _sortType = event.sortType;
    _currentPages = createPages();

    if (state is SearchResultLoaded) {
      emit((state as SearchResultLoaded).copyWith(isRefreshing: true));
    } else {
      emit(SearchResultLoading());
    }

    await _fetchSearchResults(
        emit, PageConstants.kInitialRelativePage, true);
  }

  Future<void> _onLoadPage(
      LoadPageEvent event, Emitter<SearchResultState> emit) async {
    if (state is SearchResultLoaded) {
      emit((state as SearchResultLoaded).copyWith(isRefreshing: true));
    } else {
      emit(SearchResultLoading());
    }
    await _fetchSearchResults(emit, event.offset, false);
  }

  Future<void> _onRefreshSearchResult(
      RefreshSearchResultEvent event, Emitter<SearchResultState> emit) async {
    if (state is SearchResultLoaded) {
      emit((state as SearchResultLoaded).copyWith(isRefreshing: true));
    } else {
      emit(SearchResultLoading());
    }

    _currentPages = createPages();
    await _fetchSearchResults(
        emit, PageConstants.kInitialRelativePage, true);
  }

  Future<void> _onMarkNoticeAsRead(
      MarkNoticeAsReadEvent event, Emitter<SearchResultState> emit) async {
    await ReadNoticeLocalDataSource.addReadNotice(event.noticeId);
    if (state is SearchResultLoaded) {
      final current = state as SearchResultLoaded;
      emit(current.copyWith());
    }
  }

  Future<void> _fetchSearchResults(
    Emitter<SearchResultState> emit,
    int offset,
    bool updatePages,
  ) async {
    final Either<SearchFailure, SearchResultEntity> result =
        await getSearchResultsUseCase(
      query: _query,
      offset: offset,
      sortedType: _sortType.value,
    );

    result.fold(
      (failure) => emit(SearchResultError(message: failure.message)),
      (entity) {
        Pages pages = _currentPages;
        if (offset == PageConstants.kInitialRelativePage &&
            pages['pageMetas'].isEmpty) {
          pages = Pages.from(entity.pages);
        }
        _currentPages = pages;

        final int currentPage = (offset ~/ 10) + 1;

        emit(SearchResultLoaded(
          notices: entity.notices,
          pages: pages,
          currentPage: currentPage,
          sortType: _sortType,
          isRefreshing: false,
        ));
      },
    );
  }
}
