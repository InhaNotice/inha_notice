/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-19
 */

import 'package:equatable/equatable.dart';
import 'package:inha_notice/features/search/domain/entities/trending_topic_entity.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<TrendingTopicEntity> trendingTopics;
  final List<String> recentSearchWords;
  final String makeTimes;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.trendingTopics = const [],
    this.recentSearchWords = const [],
    this.makeTimes = '',
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<TrendingTopicEntity>? trendingTopics,
    List<String>? recentSearchWords,
    String? makeTimes,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      trendingTopics: trendingTopics ?? this.trendingTopics,
      recentSearchWords: recentSearchWords ?? this.recentSearchWords,
      makeTimes: makeTimes ?? this.makeTimes,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        trendingTopics,
        recentSearchWords,
        makeTimes,
        errorMessage,
      ];
}
