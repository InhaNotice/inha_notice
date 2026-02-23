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
import 'package:inha_notice/features/user_preference/domain/entities/bookmark_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/notice_board_default_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/user_preference_entity.dart';
import 'package:inha_notice/features/user_preference/domain/failures/user_preference_failure.dart';
import 'package:inha_notice/features/user_preference/domain/repositories/user_preference_repository.dart';
import 'package:inha_notice/features/user_preference/domain/usecases/get_user_preference_use_case.dart';
import 'package:inha_notice/features/user_preference/domain/usecases/update_user_preference_use_case.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_bloc.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_event.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_state.dart';

class _FakeUserPreferenceRepository implements UserPreferenceRepository {
  Either<UserPreferenceFailure, UserPreferenceEntity> getResult = Right(
    const UserPreferenceEntity(
      noticeBoardDefault: NoticeBoardDefaultType.general,
      bookmarkDefaultSort: BookmarkDefaultSortType.newest,
      searchResultDefaultSort: SearchResultDefaultSortType.rank,
    ),
  );

  Future<Either<UserPreferenceFailure, UserPreferenceEntity>>? updateResult;

  @override
  Either<UserPreferenceFailure, UserPreferenceEntity> getUserPreferences() {
    return getResult;
  }

  @override
  Future<Either<UserPreferenceFailure, UserPreferenceEntity>>
      updateUserPreferences(UserPreferenceEntity preferences) async {
    return updateResult ??
        Future.value(
          Right(preferences),
        );
  }
}

void main() {
  group('UserPreferenceBloc 테스트', () {
    late _FakeUserPreferenceRepository repository;
    late UserPreferenceBloc bloc;

    setUp(() {
      repository = _FakeUserPreferenceRepository();
      bloc = UserPreferenceBloc(
        getUserPreferencesUseCase:
            GetUserPreferenceUseCase(repository: repository),
        updateUserPreferencesUseCase:
            UpdateUserPreferenceUseCase(repository: repository),
      );
    });

    tearDown(() async {
      await bloc.close();
    });

    test('초기 상태는 UserPreferenceInitial', () {
      expect(bloc.state, isA<UserPreferenceInitial>());
    });

    blocTest<UserPreferenceBloc, UserPreferenceState>(
      '사용자 설정 로드 성공 시 UserPreferenceLoaded 상태로 전환',
      build: () => bloc,
      act: (bloc) => bloc.add(const LoadUserPreferenceEvent()),
      expect: () => [
        isA<UserPreferenceLoading>(),
        isA<UserPreferenceLoaded>().having(
          (state) => state.preferences.noticeBoardDefault,
          'noticeBoardDefault',
          NoticeBoardDefaultType.general,
        ),
      ],
    );

    blocTest<UserPreferenceBloc, UserPreferenceState>(
      '사용자 설정 로드 실패 시 UserPreferenceError 상태로 전환',
      build: () {
        repository.getResult = const Left(
          UserPreferenceFailure.storage('저장소 오류'),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadUserPreferenceEvent()),
      expect: () => [
        isA<UserPreferenceLoading>(),
        isA<UserPreferenceError>().having(
          (state) => state.message,
          'message',
          '저장소 오류',
        ),
      ],
    );

    blocTest<UserPreferenceBloc, UserPreferenceState>(
      '공지사항 기본 탭 업데이트 성공',
      build: () => bloc,
      seed: () => const UserPreferenceLoaded(
        preferences: UserPreferenceEntity(
          noticeBoardDefault: NoticeBoardDefaultType.general,
          bookmarkDefaultSort: BookmarkDefaultSortType.newest,
          searchResultDefaultSort: SearchResultDefaultSortType.rank,
        ),
      ),
      act: (bloc) => bloc.add(
        const UpdateNoticeBoardDefaultEvent(
          type: NoticeBoardDefaultType.headline,
        ),
      ),
      expect: () => [
        isA<UserPreferenceLoaded>().having(
          (state) => state.preferences.noticeBoardDefault,
          'noticeBoardDefault',
          NoticeBoardDefaultType.headline,
        ),
      ],
    );

    blocTest<UserPreferenceBloc, UserPreferenceState>(
      '북마크 기본 정렬 업데이트 성공',
      build: () => bloc,
      seed: () => const UserPreferenceLoaded(
        preferences: UserPreferenceEntity(
          noticeBoardDefault: NoticeBoardDefaultType.general,
          bookmarkDefaultSort: BookmarkDefaultSortType.newest,
          searchResultDefaultSort: SearchResultDefaultSortType.rank,
        ),
      ),
      act: (bloc) => bloc.add(
        const UpdateBookmarkDefaultSortEvent(
          type: BookmarkDefaultSortType.oldest,
        ),
      ),
      expect: () => [
        isA<UserPreferenceLoaded>().having(
          (state) => state.preferences.bookmarkDefaultSort,
          'bookmarkDefaultSort',
          BookmarkDefaultSortType.oldest,
        ),
      ],
    );

    blocTest<UserPreferenceBloc, UserPreferenceState>(
      '검색 결과 기본 정렬 업데이트 성공',
      build: () => bloc,
      seed: () => const UserPreferenceLoaded(
        preferences: UserPreferenceEntity(
          noticeBoardDefault: NoticeBoardDefaultType.general,
          bookmarkDefaultSort: BookmarkDefaultSortType.newest,
          searchResultDefaultSort: SearchResultDefaultSortType.rank,
        ),
      ),
      act: (bloc) => bloc.add(
        const UpdateSearchResultDefaultSortEvent(
          type: SearchResultDefaultSortType.date,
        ),
      ),
      expect: () => [
        isA<UserPreferenceLoaded>().having(
          (state) => state.preferences.searchResultDefaultSort,
          'searchResultDefaultSort',
          SearchResultDefaultSortType.date,
        ),
      ],
    );

    blocTest<UserPreferenceBloc, UserPreferenceState>(
      '설정 업데이트 실패 시 UserPreferenceError 상태로 전환',
      build: () {
        repository.updateResult = Future.value(
          const Left(UserPreferenceFailure.storage('저장 실패')),
        );
        return bloc;
      },
      seed: () => const UserPreferenceLoaded(
        preferences: UserPreferenceEntity(
          noticeBoardDefault: NoticeBoardDefaultType.general,
          bookmarkDefaultSort: BookmarkDefaultSortType.newest,
          searchResultDefaultSort: SearchResultDefaultSortType.rank,
        ),
      ),
      act: (bloc) => bloc.add(
        const UpdateNoticeBoardDefaultEvent(
          type: NoticeBoardDefaultType.headline,
        ),
      ),
      expect: () => [
        isA<UserPreferenceError>().having(
          (state) => state.message,
          'message',
          '저장 실패',
        ),
      ],
    );
  });
}
