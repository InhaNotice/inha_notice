/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-09
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inha_notice/features/search/domain/entities/trending_topic_entity.dart';
import 'package:inha_notice/features/search/domain/failures/search_failure.dart';
import 'package:inha_notice/features/search/domain/usecases/add_recent_search_word_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/clear_recent_search_words_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/get_recent_search_words_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/get_trending_topics_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/remove_recent_search_word_use_case.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_event.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  // 인기 검색어
  final GetTrendingTopicsUseCase getTrendingTopics;

  // 최근 검색어
  final GetRecentSearchWordsUseCase getRecentSearchWords;
  final AddRecentSearchWordUseCase addRecentSearchWord;
  final RemoveRecentSearchWordUseCase removeRecentSearchWord;
  final ClearRecentSearchWordsUseCase clearRecentSearchWords;

  SearchBloc({
    required this.getTrendingTopics,
    required this.getRecentSearchWords,
    required this.addRecentSearchWord,
    required this.removeRecentSearchWord,
    required this.clearRecentSearchWords,
  }) : super(const SearchState()) {
    on<LoadSearchEvent>(_onLoadSearch);
    on<AddRecentSearchWordEvent>(_onAddRecentSearch);
    on<RemoveRecentSearchWordEvent>(_onRemoveRecentSearch);
    on<ClearRecentSearchWordsEvent>(_onClearRecentSearches);
  }

  Future<void> _onLoadSearch(
    LoadSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    // 1. 로딩 상태 설정
    emit(state.copyWith(status: SearchStatus.loading));

    // 2. 최근 검색어 불러오기
    final List<String> recentSearchWords = getRecentSearchWords();

    emit(state.copyWith(
      status: SearchStatus.loading,
      recentSearchWords: recentSearchWords,
    ));

    // 3. 인기 검색어 불러오기
    final Either<SearchFailure, List<TrendingTopicEntity>>
        trendingTopicsResult = await getTrendingTopics();

    // 4. 임시 변수
    List<TrendingTopicEntity> trendingTopics = [];
    String makeTimes = '';
    String? errorMessage;

    // 5. 인기 검색어 결과 처리
    trendingTopicsResult.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (success) {
        trendingTopics = success;
        if (success.isNotEmpty) {
          makeTimes = success.first.makeTimes;
        }
      },
    );

    emit(state.copyWith(
      status: SearchStatus.loaded,
      trendingTopics: trendingTopics,
      recentSearchWords: recentSearchWords,
      makeTimes: makeTimes,
      errorMessage: errorMessage,
    ));
  }

  Future<void> _onAddRecentSearch(
    AddRecentSearchWordEvent event,
    Emitter<SearchState> emit,
  ) async {
    // 1. 새로운 최근 검색어 추가
    await addRecentSearchWord(event.query);

    // 2. 최근 검색어 다시 불러오기
    final List<String> updatedRecentSearchWords = getRecentSearchWords();

    emit(state.copyWith(recentSearchWords: updatedRecentSearchWords));
  }

  Future<void> _onRemoveRecentSearch(
    RemoveRecentSearchWordEvent event,
    Emitter<SearchState> emit,
  ) async {
    // 1. 최근 검색어에서 삭제
    await removeRecentSearchWord(event.query);

    // 2. 최근 검색어 다시 불러오기
    final List<String> updatedRecentSearchWords = getRecentSearchWords();

    emit(state.copyWith(recentSearchWords: updatedRecentSearchWords));
  }

  Future<void> _onClearRecentSearches(
    ClearRecentSearchWordsEvent event,
    Emitter<SearchState> emit,
  ) async {
    // 1. 최근 검색어 모두 삭제
    await clearRecentSearchWords();

    emit(state.copyWith(recentSearchWords: []));
  }
}
