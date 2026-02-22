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
import 'package:inha_notice/features/user_preference/domain/usecases/update_user_preference_use_case.dart';

class _FakeUserPreferenceRepository implements UserPreferenceRepository {
  Future<Either<UserPreferenceFailure, UserPreferenceEntity>>? updateResult;

  @override
  Either<UserPreferenceFailure, UserPreferenceEntity> getUserPreferences() {
    throw UnimplementedError();
  }

  @override
  Future<Either<UserPreferenceFailure, UserPreferenceEntity>>
      updateUserPreferences(UserPreferenceEntity preferences) async {
    return updateResult ?? Future.value(Right(preferences));
  }
}

void main() {
  group('UpdateUserPreferenceUseCase 테스트', () {
    late _FakeUserPreferenceRepository repository;
    late UpdateUserPreferenceUseCase useCase;

    setUp(() {
      repository = _FakeUserPreferenceRepository();
      useCase = UpdateUserPreferenceUseCase(repository: repository);
    });

    test('Repository의 updateUserPreferences를 호출하고 결과 반환', () async {
      // Arrange
      const preferences = UserPreferenceEntity(
        noticeBoardDefault: NoticeBoardDefaultType.headline,
        bookmarkDefaultSort: BookmarkDefaultSortType.name,
        searchResultDefaultSort: SearchResultDefaultSortType.date,
      );
      repository.updateResult = Future.value(Right(preferences));

      // Act
      final result = await useCase(preferences);

      // Assert
      expect(result, isA<Right<UserPreferenceFailure, UserPreferenceEntity>>());
      result.fold(
        (failure) => fail('Should return Right'),
        (entity) {
          expect(entity, preferences);
        },
      );
    });

    test('Repository에서 실패 시 Failure 반환', () async {
      // Arrange
      const preferences = UserPreferenceEntity(
        noticeBoardDefault: NoticeBoardDefaultType.general,
        bookmarkDefaultSort: BookmarkDefaultSortType.newest,
        searchResultDefaultSort: SearchResultDefaultSortType.rank,
      );
      const failure = UserPreferenceFailure.storage('저장 실패');
      repository.updateResult = Future.value(const Left(failure));

      // Act
      final result = await useCase(preferences);

      // Assert
      expect(result, isA<Left<UserPreferenceFailure, UserPreferenceEntity>>());
      result.fold(
        (failure) {
          expect(failure, isA<UserPreferenceFailure>());
          expect(failure.message, '저장 실패');
        },
        (entity) => fail('Should return Left'),
      );
    });
  });
}
