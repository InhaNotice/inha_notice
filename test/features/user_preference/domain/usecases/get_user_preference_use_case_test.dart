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
import 'package:inha_notice/features/user_preference/domain/entities/bookmark_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/notice_board_default_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/user_preference_entity.dart';
import 'package:inha_notice/features/user_preference/domain/failures/user_preference_failure.dart';
import 'package:inha_notice/features/user_preference/domain/repositories/user_preference_repository.dart';
import 'package:inha_notice/features/user_preference/domain/usecases/get_user_preference_use_case.dart';

class _FakeUserPreferenceRepository implements UserPreferenceRepository {
  Either<UserPreferenceFailure, UserPreferenceEntity> result = Right(
    const UserPreferenceEntity(
      noticeBoardDefault: NoticeBoardDefaultType.general,
      bookmarkDefaultSort: BookmarkDefaultSortType.newest,
      searchResultDefaultSort: SearchResultDefaultSortType.rank,
    ),
  );

  @override
  Either<UserPreferenceFailure, UserPreferenceEntity> getUserPreferences() {
    return result;
  }

  @override
  Future<Either<UserPreferenceFailure, UserPreferenceEntity>>
      updateUserPreferences(UserPreferenceEntity preferences) async {
    throw UnimplementedError();
  }
}

void main() {
  group('GetUserPreferenceUseCase 테스트', () {
    late _FakeUserPreferenceRepository repository;
    late GetUserPreferenceUseCase useCase;

    setUp(() {
      repository = _FakeUserPreferenceRepository();
      useCase = GetUserPreferenceUseCase(repository: repository);
    });

    test('Repository의 getUserPreferences를 호출하고 결과 반환', () {
      // Arrange
      const expected = UserPreferenceEntity(
        noticeBoardDefault: NoticeBoardDefaultType.headline,
        bookmarkDefaultSort: BookmarkDefaultSortType.oldest,
        searchResultDefaultSort: SearchResultDefaultSortType.date,
      );
      repository.result = Right(expected);

      // Act
      final result = useCase();

      // Assert
      expect(result, isA<Right<UserPreferenceFailure, UserPreferenceEntity>>());
      result.fold(
        (failure) => fail('Should return Right'),
        (entity) {
          expect(entity, expected);
        },
      );
    });

    test('Repository에서 실패 시 Failure 반환', () {
      // Arrange
      const failure = UserPreferenceFailure.storage('오류 발생');
      repository.result = const Left(failure);

      // Act
      final result = useCase();

      // Assert
      expect(result, isA<Left<UserPreferenceFailure, UserPreferenceEntity>>());
      result.fold(
        (failure) {
          expect(failure, isA<UserPreferenceFailure>());
          expect(failure.message, '오류 발생');
        },
        (entity) => fail('Should return Left'),
      );
    });
  });
}
