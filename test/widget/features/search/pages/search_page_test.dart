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
import 'package:flutter/material.dart';
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
import 'package:inha_notice/features/search/presentation/pages/search_page.dart';
import 'package:inha_notice/injection_container.dart' as di;

import '../../../support/widget_test_pump_app.dart';

class _FakeSearchRepository implements SearchRepository {
  Either<SearchFailure, List<TrendingTopicEntity>> trendingResult =
      const Right([]);
  List<String> recentWords = [];

  @override
  Future<Either<SearchFailure, void>> addRecentSearchWord(String query) async {
    recentWords = [query, ...recentWords.where((e) => e != query)];
    return const Right(null);
  }

  @override
  Future<Either<SearchFailure, void>> clearRecentSearchWords() async {
    recentWords = [];
    return const Right(null);
  }

  @override
  List<String> getRecentSearchWords() {
    return List<String>.from(recentWords);
  }

  @override
  Future<Either<SearchFailure, List<TrendingTopicEntity>>>
      getTrendingTopics() async {
    return trendingResult;
  }

  @override
  Future<Either<SearchFailure, void>> removeRecentSearchWord(
      String query) async {
    recentWords.remove(query);
    return const Right(null);
  }
}

void main() {
  group('SearchPage 위젯 테스트', () {
    late _FakeSearchRepository repository;

    setUp(() async {
      await di.sl.reset();
      repository = _FakeSearchRepository()
        ..recentWords = ['학사', '장학']
        ..trendingResult = const Right([
          TrendingTopicEntity(
            id: '1',
            queryCount: '1',
            count: '10',
            updown: 'U',
            text: '컴퓨터공학과',
            makeTimes: '12:00',
          ),
        ]);

      di.sl.registerFactory<SearchBloc>(
        () => SearchBloc(
          getTrendingTopics: GetTrendingTopicsUseCase(repository),
          getRecentSearchWords: GetRecentSearchWordsUseCase(repository),
          addRecentSearchWord: AddRecentSearchWordUseCase(repository),
          removeRecentSearchWord: RemoveRecentSearchWordUseCase(repository),
          clearRecentSearchWords: ClearRecentSearchWordsUseCase(repository),
        ),
      );
    });

    tearDown(() async {
      await di.sl.reset();
    });

    testWidgets('최근 검색어와 실시간 인기 검색어를 렌더링한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const SearchPage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('최근 검색어'), findsOneWidget);
      expect(find.text('학사'), findsOneWidget);
      expect(find.text('장학'), findsOneWidget);
      expect(find.text('실시간 인기 검색어'), findsOneWidget);
      expect(find.text('컴퓨터공학과'), findsOneWidget);
      expect(find.text('12:00'), findsOneWidget);
    });

    testWidgets('전체삭제 탭 시 최근 검색어를 비운다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const SearchPage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('전체삭제'));
      await tester.pumpAndSettle();

      expect(find.text('최근 검색 기록이 없습니다.'), findsOneWidget);
    });

    testWidgets('두 글자 미만 검색어 입력 시 경고 스낵바를 노출한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const SearchPage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'a');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(find.text('검색어는 두 글자 이상 입력해주세요.'), findsOneWidget);
    });
  });
}
