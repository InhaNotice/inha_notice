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
import 'package:inha_notice/features/user_preference/domain/usecases/update_user_preference_use_case.dart';
import 'package:inha_notice/features/user_preference/presentation/bloc/user_preference_bloc.dart';
import 'package:inha_notice/features/user_preference/presentation/pages/user_preference_page.dart';
import 'package:inha_notice/injection_container.dart' as di;

import '../../../support/widget_test_pump_app.dart';

class _FakeUserPreferenceRepository implements UserPreferenceRepository {
  Either<UserPreferenceFailure, UserPreferenceEntity> getResult = const Right(
    UserPreferenceEntity(
      noticeBoardDefault: NoticeBoardDefaultType.general,
      bookmarkDefaultSort: BookmarkDefaultSortType.newest,
      searchResultDefaultSort: SearchResultDefaultSortType.rank,
    ),
  );
  Either<UserPreferenceFailure, UserPreferenceEntity> updateResult =
      const Right(
    UserPreferenceEntity(
      noticeBoardDefault: NoticeBoardDefaultType.general,
      bookmarkDefaultSort: BookmarkDefaultSortType.newest,
      searchResultDefaultSort: SearchResultDefaultSortType.rank,
    ),
  );

  @override
  Either<UserPreferenceFailure, UserPreferenceEntity> getUserPreferences() {
    return getResult;
  }

  @override
  Future<Either<UserPreferenceFailure, UserPreferenceEntity>>
      updateUserPreferences(UserPreferenceEntity preferences) async {
    return updateResult;
  }
}

void main() {
  group('UserPreferencePage Widget 테스트', () {
    late _FakeUserPreferenceRepository userPreferenceRepository;
    setUp(() async {
      await di.sl.reset();

      userPreferenceRepository = _FakeUserPreferenceRepository();

      di.sl.registerFactory<UserPreferenceBloc>(
        () => UserPreferenceBloc(
          getUserPreferencesUseCase:
              GetUserPreferenceUseCase(repository: userPreferenceRepository),
          updateUserPreferencesUseCase:
              UpdateUserPreferenceUseCase(repository: userPreferenceRepository),
        ),
      );
    });

    tearDown(() async {
      await di.sl.reset();
    });

    Future<void> pumpUserPreferencePage(WidgetTester tester) async {
      await pumpInhaApp(
        tester,
        child: const UserPreferencePage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('에러 상태일 때 에러 메시지 표시', (tester) async {
      // Arrange
      const errorMessage = '설정을 불러올 수 없습니다';
      userPreferenceRepository.getResult =
          const Left(UserPreferenceFailure.storage(errorMessage));

      // Act
      await pumpUserPreferencePage(tester);

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('로드 완료 시 설정 타일들 표시', (tester) async {
      // Arrange
      const preferences = UserPreferenceEntity(
        noticeBoardDefault: NoticeBoardDefaultType.general,
        bookmarkDefaultSort: BookmarkDefaultSortType.newest,
        searchResultDefaultSort: SearchResultDefaultSortType.rank,
      );
      userPreferenceRepository.getResult = const Right(preferences);

      // Act
      await pumpUserPreferencePage(tester);

      // Assert
      expect(find.text('기본 정렬 설정'), findsOneWidget);
      expect(find.text('공지사항'), findsOneWidget);
      expect(find.text('북마크'), findsOneWidget);
      expect(find.text('검색 결과'), findsOneWidget);
    });

    testWidgets('설정값이 올바르게 표시됨', (tester) async {
      // Arrange
      const preferences = UserPreferenceEntity(
        noticeBoardDefault: NoticeBoardDefaultType.headline,
        bookmarkDefaultSort: BookmarkDefaultSortType.oldest,
        searchResultDefaultSort: SearchResultDefaultSortType.date,
      );
      userPreferenceRepository.getResult = const Right(preferences);

      // Act
      await pumpUserPreferencePage(tester);

      // Assert
      expect(find.text('중요'), findsOneWidget); // NoticeBoardDefault
      expect(find.text('과거순'), findsOneWidget); // BookmarkSort
      expect(find.text('최신순'), findsOneWidget); // SearchResultSort
    });
  });
}
