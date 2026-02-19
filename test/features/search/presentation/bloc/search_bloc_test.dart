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
import 'package:inha_notice/features/search/presentation/bloc/search_bloc.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_event.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_state.dart';

class _FakeSearchRepository implements SearchRepository {
  List<String> recentWords = [];
  Either<SearchFailure, List<TrendingTopicEntity>> trendingResult =
      const Right([]);

  @override
  Future<Either<SearchFailure, void>> addRecentSearchWord(String query) async {
    recentWords = [query, ...recentWords.where((word) => word != query)];
    return const Right(null);
  }

  @override
  Future<Either<SearchFailure, void>> clearRecentSearchWords() async {
    recentWords = [];
    return const Right(null);
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
    recentWords = recentWords.where((word) => word != query).toList();
    return const Right(null);
  }
}

Future<void> _flushEvents([int times = 20]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('SearchBloc 유닛 테스트', () {
    late _FakeSearchRepository repository;
    late SearchBloc bloc;

    setUp(() {
      repository = _FakeSearchRepository();
      bloc = SearchBloc(
        getTrendingTopics: GetTrendingTopicsUseCase(repository),
        getRecentSearchWords: GetRecentSearchWordsUseCase(repository),
        addRecentSearchWord: AddRecentSearchWordUseCase(repository),
        removeRecentSearchWord: RemoveRecentSearchWordUseCase(repository),
        clearRecentSearchWords: ClearRecentSearchWordsUseCase(repository),
      );
    });

    tearDown(() async {
      await bloc.close();
    });

    test('LoadSearchEvent 성공 시 loaded 상태와 makeTimes를 반영한다', () async {
      repository.recentWords = ['학과'];
      repository.trendingResult = Right([
        const TrendingTopicEntity(
          id: '1',
          queryCount: '1',
          count: '99',
          updown: 'N',
          text: '장학',
          makeTimes: '14:20',
        ),
      ]);

      final emitted = <SearchState>[];
      final sub = bloc.stream.listen(emitted.add);

      bloc.add(LoadSearchEvent());
      await _flushEvents();

      await sub.cancel();

      expect(emitted.first.status, SearchStatus.loading);
      expect(bloc.state.status, SearchStatus.loaded);
      expect(bloc.state.recentSearchWords, ['학과']);
      expect(bloc.state.trendingTopics.first.text, '장학');
      expect(bloc.state.makeTimes, '14:20');
      expect(bloc.state.errorMessage, isNull);
    });

    test('LoadSearchEvent 실패 시 loaded 상태로 에러 메시지를 보관한다', () async {
      repository.recentWords = ['학과'];
      repository.trendingResult = const Left(SearchFailure.server());

      bloc.add(LoadSearchEvent());
      await _flushEvents();

      expect(bloc.state.status, SearchStatus.loaded);
      expect(bloc.state.trendingTopics, isEmpty);
      expect(bloc.state.errorMessage, 'API 서버 연결 실패');
    });

    test('AddRecentSearchWordEvent는 최근 검색어 목록을 갱신한다', () async {
      repository.recentWords = ['학과'];

      bloc.add(AddRecentSearchWordEvent(query: '장학'));
      await _flushEvents();

      expect(bloc.state.recentSearchWords, ['장학', '학과']);
    });

    test('RemoveRecentSearchWordEvent는 최근 검색어를 제거한다', () async {
      repository.recentWords = ['장학', '학과'];

      bloc.add(RemoveRecentSearchWordEvent(query: '장학'));
      await _flushEvents();

      expect(bloc.state.recentSearchWords, ['학과']);
    });

    test('ClearRecentSearchWordsEvent는 최근 검색어를 비운다', () async {
      repository.recentWords = ['장학', '학과'];

      bloc.add(ClearRecentSearchWordsEvent());
      await _flushEvents();

      expect(bloc.state.recentSearchWords, isEmpty);
    });
  });
}
