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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:inha_notice/features/user_preference/presentation/widgets/search_result_sort_preference_tile.dart';

import '../../../support/widget_test_pump_app.dart';

class _FakeUserPreferenceRepository implements UserPreferenceRepository {
  Either<UserPreferenceFailure, UserPreferenceEntity> getResult = const Right(
    UserPreferenceEntity(
      noticeBoardDefault: NoticeBoardDefaultType.general,
      bookmarkDefaultSort: BookmarkDefaultSortType.newest,
      searchResultDefaultSort: SearchResultDefaultSortType.rank,
    ),
  );

  UserPreferenceEntity? lastUpdated;

  @override
  Either<UserPreferenceFailure, UserPreferenceEntity> getUserPreferences() {
    return getResult;
  }

  @override
  Future<Either<UserPreferenceFailure, UserPreferenceEntity>>
      updateUserPreferences(UserPreferenceEntity preferences) async {
    lastUpdated = preferences;
    return Right(preferences);
  }
}

void main() {
  group('SearchResultSortPreferenceTile 위젯 테스트', () {
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

    Future<void> pumpWidget(
      WidgetTester tester, {
      required SearchResultDefaultSortType currentType,
    }) async {
      await pumpInhaApp(
        tester,
        child: BlocProvider<UserPreferenceBloc>.value(
          value: bloc,
          child: SearchResultSortPreferenceTile(currentType: currentType),
        ),
      );
      await tester.pump();
    }

    testWidgets('아이콘과 제목, 현재 설정값을 렌더링한다', (tester) async {
      // Arrange & Act
      await pumpWidget(tester, currentType: SearchResultDefaultSortType.rank);

      // Assert
      expect(find.byIcon(Icons.search_outlined), findsOneWidget);
      expect(find.text('검색 결과'), findsOneWidget);
      expect(find.text('정확도순'), findsOneWidget);
    });

    testWidgets('다른 설정값으로 렌더링된다', (tester) async {
      // Arrange & Act
      await pumpWidget(tester, currentType: SearchResultDefaultSortType.date);

      // Assert
      expect(find.text('검색 결과'), findsOneWidget);
      expect(find.text('최신순'), findsOneWidget);
    });

    testWidgets('탭 시 다이얼로그를 연다', (tester) async {
      // Arrange
      await pumpWidget(tester, currentType: SearchResultDefaultSortType.rank);

      // Act
      await tester.tap(find.text('검색 결과'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('다이얼로그에 모든 옵션이 표시된다', (tester) async {
      // Arrange
      await pumpWidget(tester, currentType: SearchResultDefaultSortType.rank);

      // Act
      await tester.tap(find.text('검색 결과'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('정확도순'), findsNWidgets(2)); // 타일 + 다이얼로그
      expect(find.text('최신순'), findsOneWidget);
      expect(find.byType(RadioListTile<SearchResultDefaultSortType>),
          findsNWidgets(2));
    });

    testWidgets('다이얼로그에서 현재 선택된 옵션이 체크된다', (tester) async {
      // Arrange
      await pumpWidget(tester, currentType: SearchResultDefaultSortType.rank);

      // Act
      await tester.tap(find.text('검색 결과'));
      await tester.pumpAndSettle();

      // Assert
      final radioTiles =
          tester.widgetList<RadioListTile<SearchResultDefaultSortType>>(
        find.byType(RadioListTile<SearchResultDefaultSortType>),
      );

      expect(radioTiles.length, 2);
      expect(radioTiles.first.groupValue, SearchResultDefaultSortType.rank);
      expect(radioTiles.first.value, SearchResultDefaultSortType.rank);
    });
  });
}
