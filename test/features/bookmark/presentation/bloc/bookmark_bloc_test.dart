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
import 'package:inha_notice/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:inha_notice/features/bookmark/domain/entities/bookmark_sorting_type.dart';
import 'package:inha_notice/features/bookmark/domain/failures/bookmark_failure.dart';
import 'package:inha_notice/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/clear_bookmarks_use_case.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/get_bookmarks_use_case.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/remove_bookmark_use_case.dart';
import 'package:inha_notice/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:inha_notice/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:inha_notice/features/bookmark/presentation/bloc/bookmark_state.dart';
import 'package:inha_notice/features/user_preference/data/datasources/user_preference_local_data_source.dart';
import 'package:inha_notice/features/user_preference/domain/entities/bookmark_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/notice_board_default_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/user_preference_entity.dart';

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

class _FakeBookmarkRepository implements BookmarkRepository {
  Either<BookmarkFailure, BookmarkEntity> getBookmarksResult =
      Right(const BookmarkEntity(bookmarks: []));
  Either<BookmarkFailure, void> removeResult = const Right(null);
  Either<BookmarkFailure, void> clearResult = const Right(null);
  int? lastRemovedId;

  @override
  Future<Either<BookmarkFailure, void>> clearBookmarks() async {
    return clearResult;
  }

  @override
  Future<Either<BookmarkFailure, BookmarkEntity>> getBookmarks() async {
    return getBookmarksResult;
  }

  @override
  Future<Either<BookmarkFailure, void>> removeBookmark(int id) async {
    lastRemovedId = id;
    return removeResult;
  }
}

Future<void> _flushEvents([int times = 20]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

List<NoticeTileModel> _sampleBookmarks() {
  return const [
    NoticeTileModel(id: '1', title: '나', link: '/1', date: '2026-02-18'),
    NoticeTileModel(id: '2', title: '가', link: '/2', date: '2026-02-20'),
    NoticeTileModel(id: '3', title: '다', link: '/3', date: '2026-02-19'),
  ];
}

void main() {
  group('BookmarkBloc 유닛 테스트', () {
    late _FakeBookmarkRepository repository;
    late BookmarkBloc bloc;

    setUp(() {
      repository = _FakeBookmarkRepository();
      bloc = BookmarkBloc(
        getBookmarksUseCase: GetBookmarksUseCase(repository: repository),
        clearBookmarksUseCase: ClearBookmarksUseCase(repository: repository),
        removeBookmarkUseCase: RemoveBookmarkUseCase(repository: repository),
        userPreferencesDataSource: _FakeUserPreferencesLocalDataSource(),
      );
    });

    tearDown(() async {
      await bloc.close();
    });

    test('LoadBookmarksEvent 성공 시 BookmarkLoaded(최신순) 상태가 된다', () async {
      repository.getBookmarksResult =
          Right(BookmarkEntity(bookmarks: _sampleBookmarks()));

      bloc.add(const LoadBookmarksEvent(isRefresh: false));
      await _flushEvents();

      expect(bloc.state, isA<BookmarkLoaded>());
      final loaded = bloc.state as BookmarkLoaded;
      expect(loaded.sortType, BookmarkSortingType.newest);
      expect(loaded.bookmarks.map((e) => e.id).toList(), ['2', '3', '1']);
    });

    test('LoadBookmarksEvent 실패 시 BookmarkError 상태가 된다', () async {
      repository.getBookmarksResult =
          const Left(BookmarkFailure.bookmarks('불러오기 실패'));

      bloc.add(const LoadBookmarksEvent(isRefresh: false));
      await _flushEvents();

      expect(bloc.state, const BookmarkError(message: '불러오기 실패'));
    });

    test('ChangeSortingEvent는 이름순 정렬을 적용한다', () async {
      repository.getBookmarksResult =
          Right(BookmarkEntity(bookmarks: _sampleBookmarks()));
      bloc.add(const LoadBookmarksEvent(isRefresh: false));
      await _flushEvents();

      bloc.add(const ChangeSortingEvent(sortType: BookmarkSortingType.name));
      await _flushEvents();

      final loaded = bloc.state as BookmarkLoaded;
      expect(loaded.bookmarks.map((e) => e.title).toList(), ['가', '나', '다']);
      expect(loaded.sortType, BookmarkSortingType.name);
    });

    test('RemoveBookmarkEvent 성공 시 삭제 후 목록을 다시 로드한다', () async {
      repository.getBookmarksResult =
          Right(BookmarkEntity(bookmarks: _sampleBookmarks()));

      bloc.add(const RemoveBookmarkEvent(id: 7));
      await _flushEvents(30);

      expect(repository.lastRemovedId, 7);
      expect(bloc.state, isA<BookmarkLoaded>());
    });

    test('RemoveBookmarkEvent 실패 시 BookmarkError 상태가 된다', () async {
      repository.removeResult = const Left(BookmarkFailure.bookmarks('삭제 실패'));

      bloc.add(const RemoveBookmarkEvent(id: 7));
      await _flushEvents();

      expect(bloc.state, const BookmarkError(message: '삭제 실패'));
    });

    test('ClearBookmarksEvent 성공 시 빈 BookmarkLoaded 상태가 된다', () async {
      bloc.add(ClearBookmarksEvent());
      await _flushEvents();

      final loaded = bloc.state as BookmarkLoaded;
      expect(loaded.bookmarks, isEmpty);
      expect(loaded.sortType, BookmarkSortingType.newest);
    });

    test('ClearBookmarksEvent 실패 시 BookmarkError 상태가 된다', () async {
      repository.clearResult =
          const Left(BookmarkFailure.bookmarks('전체 삭제 실패'));

      bloc.add(ClearBookmarksEvent());
      await _flushEvents();

      expect(bloc.state, const BookmarkError(message: '전체 삭제 실패'));
    });
  });
}
