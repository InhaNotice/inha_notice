/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-20
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:inha_notice/features/bookmark/data/models/bookmark_model.dart';
import 'package:inha_notice/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:inha_notice/features/bookmark/domain/failures/bookmark_failure.dart';
import 'package:inha_notice/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/clear_bookmarks_use_case.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/get_bookmarks_use_case.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/remove_bookmark_use_case.dart';
import 'package:inha_notice/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:inha_notice/features/bookmark/presentation/pages/bookmark_page.dart';
import 'package:inha_notice/features/user_preference/data/datasources/user_preference_local_data_source.dart';
import 'package:inha_notice/features/user_preference/domain/entities/bookmark_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/notice_board_default_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/user_preference_entity.dart';
import 'package:inha_notice/injection_container.dart' as di;

import '../../../support/widget_test_pump_app.dart';

class _FakeBookmarkRepository implements BookmarkRepository {
  Either<BookmarkFailure, BookmarkEntity> getResult =
      Right(const BookmarkEntity(bookmarks: []));
  Either<BookmarkFailure, void> clearResult = const Right(null);

  @override
  Future<Either<BookmarkFailure, void>> clearBookmarks() async {
    return clearResult;
  }

  @override
  Future<Either<BookmarkFailure, BookmarkEntity>> getBookmarks() async {
    return getResult;
  }

  @override
  Future<Either<BookmarkFailure, void>> removeBookmark(int id) async {
    return const Right(null);
  }
}

class _FakeBookmarkLocalDataSource implements BookmarkLocalDataSource {
  final Set<String> ids = {};

  @override
  Future<void> addBookmark(NoticeTileModel notice) async {
    ids.add(notice.id);
  }

  @override
  Future<void> clearBookmarks() async {
    ids.clear();
  }

  @override
  Set<String> getBookmarkIds() => ids;

  @override
  Future<BookmarkModel> getBookmarks() async {
    return const BookmarkModel(bookmarks: []);
  }

  @override
  Future<void> initialize() async {}

  @override
  bool isBookmarked(String noticeId) => ids.contains(noticeId);

  @override
  Future<void> removeBookmark(String noticeId) async {
    ids.remove(noticeId);
  }
}

class _FakeUserPreferencesLocalDataSource
    implements UserPreferenceLocalDataSource {
  @override
  UserPreferenceEntity getUserPreferences() {
    return const UserPreferenceEntity(
      noticeBoardDefault: NoticeBoardDefaultType.general,
      bookmarkDefaultSort: BookmarkDefaultSortType.newest,
      searchResultDefaultSort: SearchResultDefaultSortType.rank,
    );
  }

  @override
  Future<void> saveUserPreferences(UserPreferenceEntity preferences) async {}
}

void main() {
  group('BookmarkPage 위젯 테스트', () {
    late _FakeBookmarkRepository repository;

    setUp(() async {
      await di.sl.reset();

      repository = _FakeBookmarkRepository()
        ..getResult = Right(const BookmarkEntity(bookmarks: []));

      di.sl.registerFactory<BookmarkBloc>(
        () => BookmarkBloc(
          getBookmarksUseCase: GetBookmarksUseCase(repository: repository),
          clearBookmarksUseCase: ClearBookmarksUseCase(repository: repository),
          removeBookmarkUseCase: RemoveBookmarkUseCase(repository: repository),
          userPreferencesDataSource: _FakeUserPreferencesLocalDataSource(),
        ),
      );
      di.sl.registerLazySingleton<BookmarkLocalDataSource>(
        () => _FakeBookmarkLocalDataSource(),
      );
    });

    tearDown(() async {
      await di.sl.reset();
    });

    testWidgets('북마크가 비어있으면 빈 상태 문구를 표시한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const BookmarkPage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('북마크한 공지사항이 없어요.'), findsOneWidget);
      expect(find.text('최신순'), findsOneWidget);
      expect(find.text('과거순'), findsOneWidget);
      expect(find.text('이름순'), findsOneWidget);
    });

    testWidgets('정렬 토글 탭 후에도 빈 상태 문구를 유지한다', (tester) async {
      await pumpInhaApp(
        tester,
        child: const BookmarkPage(),
        wrapWithScaffold: false,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('이름순'));
      await tester.pumpAndSettle();

      expect(find.text('북마크한 공지사항이 없어요.'), findsOneWidget);
    });
  });
}
