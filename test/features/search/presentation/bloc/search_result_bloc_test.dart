/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/features/search/domain/entities/search_result_entity.dart';
import 'package:inha_notice/features/search/domain/failures/search_result_failure.dart';
import 'package:inha_notice/features/search/domain/repositories/search_result_repository.dart';
import 'package:inha_notice/features/search/domain/usecases/search_notices_use_case.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_result_bloc.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_result_event.dart';
import 'package:inha_notice/features/search/presentation/bloc/search_result_state.dart';

class _FakeSearchResultRepository implements SearchResultRepository {
  @override
  Future<Either<SearchResultFailure, SearchResultEntity>> searchNotices({
    required String query,
    required int startCount,
    required String sortType,
  }) async {
    throw UnimplementedError();
  }
}

class _FakeSearchNoticesUseCase extends SearchNoticesUseCase {
  _FakeSearchNoticesUseCase() : super(repository: _FakeSearchResultRepository());

  Either<SearchResultFailure, SearchResultEntity>? result;

  @override
  Future<Either<SearchResultFailure, SearchResultEntity>> call({
    required String query,
    required int startCount,
    required String sortType,
  }) async {
    return result ?? Left(SearchResultFailure.unknown('No result set'));
  }
}

void main() {
  group('SearchResultBloc 테스트', () {
    late SearchResultBloc sut;
    late _FakeSearchNoticesUseCase fakeUseCase;

    setUp(() {
      fakeUseCase = _FakeSearchNoticesUseCase();
      sut = SearchResultBloc(searchNoticesUseCase: fakeUseCase);
    });

    tearDown(() async {
      await sut.close();
    });

    test('초기 상태는 SearchResultInitial이다', () {
      expect(sut.state, isA<SearchResultInitial>());
    });

    group('SearchNoticesRequestedEvent', () {
      blocTest<SearchResultBloc, SearchResultState>(
        '검색 성공 시 [Loading, Loaded] 상태를 방출한다',
        build: () {
          final entity = SearchResultEntity(
            notices: [
              NoticeTileModel(
                id: 'test-1',
                title: '테스트 공지',
                body: '테스트 내용',
                link: 'https://test.com',
                date: '2026-02-22',
              ),
            ],
            pages: createPages(),
          );
          fakeUseCase.result = Right(entity);
          return sut;
        },
        act: (bloc) => bloc.add(
          const SearchNoticesRequestedEvent(
            query: '테스트',
            startCount: 0,
            sortType: 'RANK',
          ),
        ),
        expect: () => [
          isA<SearchResultLoading>(),
          isA<SearchResultLoaded>()
              .having((s) => s.notices.length, 'notices length', 1)
              .having((s) => s.query, 'query', '테스트')
              .having((s) => s.currentPage, 'currentPage', 0)
              .having((s) => s.sortType, 'sortType', 'RANK'),
        ],
      );

      blocTest<SearchResultBloc, SearchResultState>(
        '검색 실패 시 [Loading, Error] 상태를 방출한다',
        build: () {
          fakeUseCase.result =
              const Left(SearchResultFailure.network('Network error'));
          return sut;
        },
        act: (bloc) => bloc.add(
          const SearchNoticesRequestedEvent(
            query: '테스트',
            startCount: 0,
            sortType: 'RANK',
          ),
        ),
        expect: () => [
          isA<SearchResultLoading>(),
          isA<SearchResultError>()
              .having((s) => s.message, 'message', 'Network error'),
        ],
      );

      blocTest<SearchResultBloc, SearchResultState>(
        '빈 검색 결과도 정상적으로 처리한다',
        build: () {
          final entity = SearchResultEntity(
            notices: [],
            pages: createPages(),
          );
          fakeUseCase.result = Right(entity);
          return sut;
        },
        act: (bloc) => bloc.add(
          const SearchNoticesRequestedEvent(
            query: '존재하지않는검색어',
            startCount: 0,
            sortType: 'DATE',
          ),
        ),
        expect: () => [
          isA<SearchResultLoading>(),
          isA<SearchResultLoaded>()
              .having((s) => s.notices.isEmpty, 'notices is empty', true),
        ],
      );
    });

    group('SearchPageChangedEvent', () {
      blocTest<SearchResultBloc, SearchResultState>(
        '페이지 변경 시 새로운 데이터를 로드한다',
        build: () {
          final entity = SearchResultEntity(
            notices: [
              NoticeTileModel(
                id: 'test-2',
                title: '두 번째 페이지 공지',
                body: '내용',
                link: 'https://test.com',
                date: '2026-02-22',
              ),
            ],
            pages: createPages(),
          );
          fakeUseCase.result = Right(entity);
          return sut;
        },
        seed: () => SearchResultLoaded(
          notices: [
            NoticeTileModel(
              id: 'test-1',
              title: '첫 페이지 공지',
              body: '내용',
              link: 'https://test.com',
              date: '2026-02-22',
            ),
          ],
          pages: createPages(),
          query: '테스트',
          currentPage: 0,
          sortType: 'RANK',
        ),
        act: (bloc) => bloc.add(const SearchPageChangedEvent(startCount: 10)),
        expect: () => [
          isA<SearchResultLoading>(),
          isA<SearchResultLoaded>()
              .having((s) => s.currentPage, 'currentPage', 10)
              .having((s) => s.query, 'query', '테스트')
              .having((s) => s.sortType, 'sortType', 'RANK'),
        ],
      );

      blocTest<SearchResultBloc, SearchResultState>(
        'Loaded 상태가 아니면 아무 동작도 하지 않는다',
        build: () => sut,
        seed: () => SearchResultInitial(),
        act: (bloc) => bloc.add(const SearchPageChangedEvent(startCount: 10)),
        expect: () => [],
      );
    });

    group('SearchSortChangedEvent', () {
      blocTest<SearchResultBloc, SearchResultState>(
        '정렬 변경 시 첫 페이지부터 새로운 데이터를 로드한다',
        build: () {
          final entity = SearchResultEntity(
            notices: [
              NoticeTileModel(
                id: 'test-1',
                title: '정렬 변경 공지',
                body: '내용',
                link: 'https://test.com',
                date: '2026-02-22',
              ),
            ],
            pages: createPages(),
          );
          fakeUseCase.result = Right(entity);
          return sut;
        },
        seed: () => SearchResultLoaded(
          notices: [],
          pages: createPages(),
          query: '테스트',
          currentPage: 10,
          sortType: 'RANK',
        ),
        act: (bloc) => bloc.add(const SearchSortChangedEvent(sortType: 'DATE')),
        expect: () => [
          isA<SearchResultLoading>(),
          isA<SearchResultLoaded>()
              .having((s) => s.sortType, 'sortType', 'DATE')
              .having((s) => s.currentPage, 'currentPage', 0)
              .having((s) => s.query, 'query', '테스트'),
        ],
      );

      blocTest<SearchResultBloc, SearchResultState>(
        'Loaded 상태가 아니면 아무 동작도 하지 않는다',
        build: () => sut,
        seed: () => SearchResultLoading(),
        act: (bloc) => bloc.add(const SearchSortChangedEvent(sortType: 'DATE')),
        expect: () => [],
      );

      blocTest<SearchResultBloc, SearchResultState>(
        '정렬 변경 후 네트워크 오류 시 Error 상태를 방출한다',
        build: () {
          fakeUseCase.result =
              const Left(SearchResultFailure.network('Network error'));
          return sut;
        },
        seed: () => SearchResultLoaded(
          notices: [],
          pages: createPages(),
          query: '테스트',
          currentPage: 0,
          sortType: 'RANK',
        ),
        act: (bloc) => bloc.add(const SearchSortChangedEvent(sortType: 'DATE')),
        expect: () => [
          isA<SearchResultLoading>(),
          isA<SearchResultError>()
              .having((s) => s.message, 'message', 'Network error'),
        ],
      );
    });
  });
}
