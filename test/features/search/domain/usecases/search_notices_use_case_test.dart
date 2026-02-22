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
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/features/search/domain/entities/search_result_entity.dart';
import 'package:inha_notice/features/search/domain/failures/search_result_failure.dart';
import 'package:inha_notice/features/search/domain/repositories/search_result_repository.dart';
import 'package:inha_notice/features/search/domain/usecases/search_notices_use_case.dart';

class _FakeSearchResultRepository implements SearchResultRepository {
  Either<SearchResultFailure, SearchResultEntity>? result;

  @override
  Future<Either<SearchResultFailure, SearchResultEntity>> searchNotices({
    required String query,
    required int startCount,
    required String sortType,
  }) async {
    return result ?? Left(SearchResultFailure.unknown('No result set'));
  }
}

void main() {
  group('SearchNoticesUseCase 테스트', () {
    late SearchNoticesUseCase sut;
    late _FakeSearchResultRepository fakeRepository;

    setUp(() {
      fakeRepository = _FakeSearchResultRepository();
      sut = SearchNoticesUseCase(repository: fakeRepository);
    });

    test('검색 성공 시 SearchResultEntity를 반환한다', () async {
      // Arrange
      final expectedEntity = SearchResultEntity(
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
      fakeRepository.result = Right(expectedEntity);

      // Act
      final result = await sut(
        query: '테스트',
        startCount: 0,
        sortType: 'RANK',
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (entity) {
          expect(entity, expectedEntity);
          expect(entity.notices.length, 1);
          expect(entity.notices.first.title, '테스트 공지');
        },
      );
    });

    test('검색 실패 시 SearchResultFailure를 반환한다', () async {
      // Arrange
      const expectedFailure = SearchResultFailure.network('Network error');
      fakeRepository.result = const Left(expectedFailure);

      // Act
      final result = await sut(
        query: '테스트',
        startCount: 0,
        sortType: 'RANK',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, expectedFailure);
          expect(failure.message, 'Network error');
        },
        (entity) => fail('Should not return entity'),
      );
    });

    test('빈 검색 결과도 정상적으로 반환한다', () async {
      // Arrange
      final expectedEntity = SearchResultEntity(
        notices: [],
        pages: createPages(),
      );
      fakeRepository.result = Right(expectedEntity);

      // Act
      final result = await sut(
        query: '존재하지않는검색어',
        startCount: 0,
        sortType: 'DATE',
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (entity) {
          expect(entity.notices.isEmpty, true);
        },
      );
    });

    test('다양한 정렬 타입으로 검색할 수 있다', () async {
      // Arrange
      final expectedEntity = SearchResultEntity(
        notices: [],
        pages: createPages(),
      );
      fakeRepository.result = Right(expectedEntity);

      // Act & Assert - RANK
      var result = await sut(
        query: '테스트',
        startCount: 0,
        sortType: 'RANK',
      );
      expect(result.isRight(), true);

      // Act & Assert - DATE
      result = await sut(
        query: '테스트',
        startCount: 0,
        sortType: 'DATE',
      );
      expect(result.isRight(), true);
    });

    test('페이지네이션을 지원한다', () async {
      // Arrange
      final expectedEntity = SearchResultEntity(
        notices: [],
        pages: createPages(),
      );
      fakeRepository.result = Right(expectedEntity);

      // Act - 첫 페이지
      var result = await sut(
        query: '테스트',
        startCount: 0,
        sortType: 'RANK',
      );
      expect(result.isRight(), true);

      // Act - 두 번째 페이지
      result = await sut(
        query: '테스트',
        startCount: 10,
        sortType: 'RANK',
      );
      expect(result.isRight(), true);
    });
  });
}
