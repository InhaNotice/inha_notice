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
import 'package:inha_notice/features/user_preference/data/datasources/user_preference_local_data_source.dart';
import 'package:inha_notice/features/user_preference/data/repositories/user_preference_repository_impl.dart';
import 'package:inha_notice/features/user_preference/domain/entities/bookmark_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/notice_board_default_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/user_preference_entity.dart';
import 'package:inha_notice/features/user_preference/domain/failures/user_preference_failure.dart';

class _FakeUserPreferenceLocalDataSource
    implements UserPreferenceLocalDataSource {
  UserPreferenceEntity? _preferences;
  bool shouldThrowError = false;

  @override
  UserPreferenceEntity getUserPreferences() {
    if (shouldThrowError) {
      throw Exception('데이터 로드 실패');
    }
    return _preferences ??
        const UserPreferenceEntity(
          noticeBoardDefault: NoticeBoardDefaultType.general,
          bookmarkDefaultSort: BookmarkDefaultSortType.newest,
          searchResultDefaultSort: SearchResultDefaultSortType.rank,
        );
  }

  @override
  Future<void> saveUserPreferences(UserPreferenceEntity preferences) async {
    if (shouldThrowError) {
      throw Exception('데이터 저장 실패');
    }
    _preferences = preferences;
  }
}

void main() {
  group('UserPreferenceRepositoryImpl 테스트', () {
    late _FakeUserPreferenceLocalDataSource dataSource;
    late UserPreferenceRepositoryImpl repository;

    setUp(() {
      dataSource = _FakeUserPreferenceLocalDataSource();
      repository = UserPreferenceRepositoryImpl(localDataSource: dataSource);
    });

    group('getUserPreferences', () {
      test('성공 시 Right(UserPreferencesEntity) 반환', () {
        // Arrange
        const expected = UserPreferenceEntity(
          noticeBoardDefault: NoticeBoardDefaultType.headline,
          bookmarkDefaultSort: BookmarkDefaultSortType.oldest,
          searchResultDefaultSort: SearchResultDefaultSortType.date,
        );
        dataSource._preferences = expected;

        // Act
        final result = repository.getUserPreferences();

        // Assert
        expect(
            result, isA<Right<UserPreferenceFailure, UserPreferenceEntity>>());
        result.fold(
          (failure) => fail('Should return Right'),
          (entity) {
            expect(entity.noticeBoardDefault, expected.noticeBoardDefault);
            expect(entity.bookmarkDefaultSort, expected.bookmarkDefaultSort);
            expect(entity.searchResultDefaultSort,
                expected.searchResultDefaultSort);
          },
        );
      });

      test('실패 시 Left(UserPreferencesFailure) 반환', () {
        // Arrange
        dataSource.shouldThrowError = true;

        // Act
        final result = repository.getUserPreferences();

        // Assert
        expect(
            result, isA<Left<UserPreferenceFailure, UserPreferenceEntity>>());
        result.fold(
          (failure) {
            expect(failure, isA<UserPreferenceFailure>());
            expect(failure.message, contains('데이터 로드 실패'));
          },
          (entity) => fail('Should return Left'),
        );
      });
    });

    group('updateUserPreferences', () {
      test('성공 시 Right(UserPreferencesEntity) 반환', () async {
        // Arrange
        const preferences = UserPreferenceEntity(
          noticeBoardDefault: NoticeBoardDefaultType.headline,
          bookmarkDefaultSort: BookmarkDefaultSortType.name,
          searchResultDefaultSort: SearchResultDefaultSortType.date,
        );

        // Act
        final result = await repository.updateUserPreferences(preferences);

        // Assert
        expect(
            result, isA<Right<UserPreferenceFailure, UserPreferenceEntity>>());
        result.fold(
          (failure) => fail('Should return Right'),
          (entity) {
            expect(entity.noticeBoardDefault, preferences.noticeBoardDefault);
            expect(entity.bookmarkDefaultSort, preferences.bookmarkDefaultSort);
            expect(entity.searchResultDefaultSort,
                preferences.searchResultDefaultSort);
          },
        );

        // Verify saved
        final saved = dataSource.getUserPreferences();
        expect(saved.noticeBoardDefault, preferences.noticeBoardDefault);
      });

      test('실패 시 Left(UserPreferencesFailure) 반환', () async {
        // Arrange
        dataSource.shouldThrowError = true;
        const preferences = UserPreferenceEntity(
          noticeBoardDefault: NoticeBoardDefaultType.general,
          bookmarkDefaultSort: BookmarkDefaultSortType.newest,
          searchResultDefaultSort: SearchResultDefaultSortType.rank,
        );

        // Act
        final result = await repository.updateUserPreferences(preferences);

        // Assert
        expect(
            result, isA<Left<UserPreferenceFailure, UserPreferenceEntity>>());
        result.fold(
          (failure) {
            expect(failure, isA<UserPreferenceFailure>());
            expect(failure.message, contains('데이터 저장 실패'));
          },
          (entity) => fail('Should return Left'),
        );
      });
    });
  });
}
