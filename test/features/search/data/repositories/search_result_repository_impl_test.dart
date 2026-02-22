/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/features/search/data/datasources/search_scraper.dart';
import 'package:inha_notice/features/search/data/repositories/search_result_repository_impl.dart';

class _FakeSearchDataSource implements SearchDataSource {
  Map<String, dynamic>? result;
  Exception? exception;

  @override
  Future<Map<String, dynamic>> fetchNotices(
    String query,
    int startCount,
    String sortedType,
  ) async {
    if (exception != null) {
      throw exception!;
    }
    return result ??
        {
          'headline': [],
          'general': [],
          'pages': createPages(),
        };
  }
}

void main() {
  group('SearchResultRepositoryImpl 테스트', () {
    late SearchResultRepositoryImpl sut;
    late _FakeSearchDataSource fakeDataSource;

    setUp(() {
      fakeDataSource = _FakeSearchDataSource();
      sut = SearchResultRepositoryImpl(dataSource: fakeDataSource);
    });

    test('데이터 소스에서 공지사항을 성공적으로 가져온다', () async {
      // Arrange
      fakeDataSource.result = {
        'headline': [],
        'general': [
          {
            'id': 'test-1',
            'title': '테스트 공지',
            'body': '테스트 내용',
            'link': 'https://test.com',
            'date': '2026-02-22',
          },
        ],
        'pages': createPages(),
      };

      // Act
      final result = await sut.searchNotices(
        query: '테스트',
        startCount: 0,
        sortType: 'RANK',
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (entity) {
          expect(entity.notices.length, 1);
          expect(entity.notices.first.id, 'test-1');
          expect(entity.notices.first.title, '테스트 공지');
          expect(entity.pages, isA<Pages>());
        },
      );
    });

    test('빈 검색 결과를 정상적으로 처리한다', () async {
      // Arrange
      fakeDataSource.result = {
        'headline': [],
        'general': [],
        'pages': createPages(),
      };

      // Act
      final result = await sut.searchNotices(
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

    test('여러 공지사항을 올바르게 변환한다', () async {
      // Arrange
      fakeDataSource.result = {
        'headline': [],
        'general': [
          {
            'id': 'test-1',
            'title': '첫 번째 공지',
            'body': '첫 번째 내용',
            'link': 'https://test1.com',
            'date': '2026-02-22',
          },
          {
            'id': 'test-2',
            'title': '두 번째 공지',
            'body': '두 번째 내용',
            'link': 'https://test2.com',
            'date': '2026-02-21',
          },
        ],
        'pages': createPages(),
      };

      // Act
      final result = await sut.searchNotices(
        query: '테스트',
        startCount: 0,
        sortType: 'RANK',
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (entity) {
          expect(entity.notices.length, 2);
          expect(entity.notices[0].title, '첫 번째 공지');
          expect(entity.notices[1].title, '두 번째 공지');
        },
      );
    });

    test('데이터 소스 오류 시 SearchResultFailure.network를 반환한다', () async {
      // Arrange
      fakeDataSource.exception = Exception('Network error');

      // Act
      final result = await sut.searchNotices(
        query: '테스트',
        startCount: 0,
        sortType: 'RANK',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure.message, contains('Network error'));
        },
        (entity) => fail('Should not return entity'),
      );
    });

    test('페이지 정보를 올바르게 변환한다', () async {
      // Arrange
      final testPages = createPages();
      testPages['pageMetas'] = [
        {'page': 1, 'startCount': 0},
        {'page': 2, 'startCount': 10},
      ];

      fakeDataSource.result = {
        'headline': [],
        'general': [],
        'pages': testPages,
      };

      // Act
      final result = await sut.searchNotices(
        query: '테스트',
        startCount: 0,
        sortType: 'RANK',
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (entity) {
          expect(entity.pages['pageMetas'], isNotEmpty);
          expect(entity.pages['pageMetas'].length, 2);
        },
      );
    });
  });
}
