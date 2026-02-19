/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/search/domain/entities/trending_topic_entity.dart';
import 'package:inha_notice/features/search/domain/failures/search_failure.dart';
import 'package:inha_notice/features/search/domain/repositories/search_repository.dart';
import 'package:inha_notice/features/search/domain/usecases/add_recent_search_word_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/clear_recent_search_words_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/get_recent_search_words_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/get_trending_topics_use_case.dart';
import 'package:inha_notice/features/search/domain/usecases/remove_recent_search_word_use_case.dart';

class _FakeSearchRepository implements SearchRepository {
  Either<SearchFailure, List<TrendingTopicEntity>> trendingResult =
      const Right([]);
  Either<SearchFailure, void> addResult = const Right(null);
  Either<SearchFailure, void> clearResult = const Right(null);
  Either<SearchFailure, void> removeResult = const Right(null);
  List<String> recentWords = [];
  String? lastAdded;
  String? lastRemoved;

  @override
  Future<Either<SearchFailure, void>> addRecentSearchWord(String query) async {
    lastAdded = query;
    return addResult;
  }

  @override
  Future<Either<SearchFailure, void>> clearRecentSearchWords() async {
    return clearResult;
  }

  @override
  List<String> getRecentSearchWords() {
    return List.from(recentWords);
  }

  @override
  Future<Either<SearchFailure, List<TrendingTopicEntity>>>
      getTrendingTopics() async {
    return trendingResult;
  }

  @override
  Future<Either<SearchFailure, void>> removeRecentSearchWord(
      String query) async {
    lastRemoved = query;
    return removeResult;
  }
}

void main() {
  group('Search UseCase 유닛 테스트', () {
    test('GetTrendingTopicsUseCase는 저장소 결과를 그대로 반환한다', () async {
      final repository = _FakeSearchRepository()
        ..trendingResult = Right([
          const TrendingTopicEntity(
            id: '1',
            queryCount: '1',
            count: '100',
            updown: 'N',
            text: '장학',
            makeTimes: '12:30',
          ),
        ]);
      final useCase = GetTrendingTopicsUseCase(repository);

      final result = await useCase();

      expect(result.isRight(), isTrue);
    });

    test('GetRecentSearchWordsUseCase는 최근 검색어 목록을 반환한다', () {
      final repository = _FakeSearchRepository()..recentWords = ['장학', '학사'];
      final useCase = GetRecentSearchWordsUseCase(repository);

      final result = useCase();

      expect(result, ['장학', '학사']);
    });

    test('AddRecentSearchWordUseCase는 query를 전달한다', () async {
      final repository = _FakeSearchRepository();
      final useCase = AddRecentSearchWordUseCase(repository);

      final result = await useCase('모집');

      expect(repository.lastAdded, '모집');
      expect(result, const Right(null));
    });

    test('RemoveRecentSearchWordUseCase는 query를 전달한다', () async {
      final repository = _FakeSearchRepository();
      final useCase = RemoveRecentSearchWordUseCase(repository);

      await useCase('국제처');

      expect(repository.lastRemoved, '국제처');
    });

    test('ClearRecentSearchWordsUseCase는 저장소 결과를 그대로 반환한다', () async {
      final repository = _FakeSearchRepository();
      final useCase = ClearRecentSearchWordsUseCase(repository);

      final result = await useCase();

      expect(result, const Right(null));
    });
  });
}
