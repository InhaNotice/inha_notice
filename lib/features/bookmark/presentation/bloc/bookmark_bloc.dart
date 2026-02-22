/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:inha_notice/features/bookmark/domain/entities/bookmark_sorting_type.dart';
import 'package:inha_notice/features/bookmark/domain/failures/bookmark_failure.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/clear_bookmarks_use_case.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/get_bookmarks_use_case.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/remove_bookmark_use_case.dart';
import 'package:inha_notice/features/user_preference/data/datasources/user_preference_local_data_source.dart';
import 'package:inha_notice/features/user_preference/domain/entities/bookmark_default_sort_type.dart';

import 'bookmark_event.dart';
import 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final GetBookmarksUseCase getBookmarksUseCase;
  final ClearBookmarksUseCase clearBookmarksUseCase;
  final RemoveBookmarkUseCase removeBookmarkUseCase;
  final UserPreferenceLocalDataSource userPreferencesDataSource;

  BookmarkBloc({
    required this.getBookmarksUseCase,
    required this.clearBookmarksUseCase,
    required this.removeBookmarkUseCase,
    required this.userPreferencesDataSource,
  }) : super(BookmarkInitial()) {
    on<LoadBookmarksEvent>(_onLoadBookmarks);
    on<RemoveBookmarkEvent>(_onRemoveBookmark);
    on<ChangeSortingEvent>(_onChangeSorting);
    on<ClearBookmarksEvent>(_onClearBookmarks);
  }

  Future<void> _onLoadBookmarks(
      LoadBookmarksEvent event, Emitter<BookmarkState> emit) async {
    if (!event.isRefresh) {
      emit(BookmarkLoading());
    }

    // 북마크 정렬 설정값
    final BookmarkDefaultSortType defaultSortType =
        userPreferencesDataSource.getUserPreferences().bookmarkDefaultSort;
    final BookmarkSortingType sortType =
        _mapToBookmarkSortingType(defaultSortType);

    final Either<BookmarkFailure, BookmarkEntity> results =
        await getBookmarksUseCase();

    try {
      results.fold(
        (failure) {
          final String errorMessage = failure.when(bookmarks: (msg) => msg);
          emit(BookmarkError(message: errorMessage));
        },
        (bookmarkWrapper) {
          final List<NoticeTileModel> rawList = bookmarkWrapper.bookmarks;

          final List<NoticeTileModel> sortedList =
              _sortBookmarks(rawList, sortType);

          emit(BookmarkLoaded(bookmarks: sortedList, sortType: sortType));
        },
      );
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onRemoveBookmark(
      RemoveBookmarkEvent event, Emitter<BookmarkState> emit) async {
    final Either<BookmarkFailure, void> results =
        await removeBookmarkUseCase(event.id);

    results.fold(
      (failure) {
        final String errorMessage = failure.when(bookmarks: (msg) => msg);
        emit(BookmarkError(message: errorMessage));
      },
      (success) {
        add(const LoadBookmarksEvent(isRefresh: true));
      },
    );
  }

  Future<void> _onChangeSorting(
      ChangeSortingEvent event, Emitter<BookmarkState> emit) async {
    if (state is BookmarkLoaded) {
      final BookmarkLoaded currentState = state as BookmarkLoaded;

      final List<NoticeTileModel> sortedList =
          _sortBookmarks(currentState.bookmarks, event.sortType);

      emit(BookmarkLoaded(bookmarks: sortedList, sortType: event.sortType));
    }
  }

  Future<void> _onClearBookmarks(
      ClearBookmarksEvent event, Emitter<BookmarkState> emit) async {
    final Either<BookmarkFailure, void> results = await clearBookmarksUseCase();

    results.fold(
      (failure) {
        final String errorMessage = failure.when(bookmarks: (msg) => msg);
        emit(BookmarkError(message: errorMessage));
      },
      (success) {
        emit(BookmarkLoaded(
            bookmarks: [], sortType: BookmarkSortingType.newest));
      },
    );
  }

  List<NoticeTileModel> _sortBookmarks(
      List<NoticeTileModel> list, BookmarkSortingType type) {
    final List<NoticeTileModel> sortedList = List<NoticeTileModel>.from(list);

    switch (type) {
      case BookmarkSortingType.newest:
        sortedList.sort((a, b) => b.date.compareTo(a.date));
        break;
      case BookmarkSortingType.oldest:
        sortedList.sort((a, b) => a.date.compareTo(b.date));
        break;
      case BookmarkSortingType.name:
        sortedList.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return sortedList;
  }

  BookmarkSortingType _mapToBookmarkSortingType(
    BookmarkDefaultSortType type,
  ) {
    switch (type) {
      case BookmarkDefaultSortType.newest:
        return BookmarkSortingType.newest;
      case BookmarkDefaultSortType.oldest:
        return BookmarkSortingType.oldest;
      case BookmarkDefaultSortType.name:
        return BookmarkSortingType.name;
    }
  }
}
