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
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_user_setting_value_by_notice_type_use_case.dart';
import 'package:inha_notice/features/notice/domain/entities/notice_board_entity.dart';
import 'package:inha_notice/features/notice/domain/failures/notice_board_failure.dart';
import 'package:inha_notice/features/notice/domain/repositories/notice_board_repository.dart';
import 'package:inha_notice/features/notice/domain/usecases/get_notices_use_case.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_bloc.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_event.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_state.dart';
import 'package:inha_notice/features/user_preference/domain/entities/bookmark_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/notice_board_default_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/user_preference_entity.dart';
import 'package:inha_notice/features/user_preference/domain/failures/user_preference_failure.dart';
import 'package:inha_notice/features/user_preference/domain/repositories/user_preference_repository.dart';
import 'package:inha_notice/features/user_preference/domain/usecases/get_user_preference_use_case.dart';

class _FakeNoticeBoardRepository implements NoticeBoardRepository {
  Either<NoticeBoardFailure, NoticeBoardEntity> absoluteResult =
      Right(_sampleEntity());
  Either<NoticeBoardFailure, NoticeBoardEntity> relativeResult =
      Right(_sampleEntity());

  String? lastAbsoluteNoticeType;
  int? lastAbsolutePage;
  String? lastSearchColumn;
  String? lastSearchWord;
  String? lastRelativeNoticeType;
  int? lastRelativeOffset;

  @override
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchAbsoluteNotices({
    required String noticeType,
    required int page,
    String? searchColumn,
    String? searchWord,
  }) async {
    lastAbsoluteNoticeType = noticeType;
    lastAbsolutePage = page;
    lastSearchColumn = searchColumn;
    lastSearchWord = searchWord;
    return absoluteResult;
  }

  @override
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchRelativeNotices({
    required String noticeType,
    required int offset,
  }) async {
    lastRelativeNoticeType = noticeType;
    lastRelativeOffset = offset;
    return relativeResult;
  }
}

class _FakeUserPreferencesRepository implements UserPreferenceRepository {
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

class _FakeSharedPrefsManager extends SharedPrefsManager {
  _FakeSharedPrefsManager() : super(null);

  final Map<String, dynamic> values = {};

  @override
  T? getValue<T>(String key) {
    final value = values[key];
    if (value is T) return value;
    return null;
  }
}

NoticeBoardEntity _sampleEntity() {
  return NoticeBoardEntity(
    headlineNotices: const [
      NoticeTileModel(id: 'h1', title: '헤드라인', link: '/h1', date: '2026-01-01'),
    ],
    generalNotices: const [
      NoticeTileModel(id: 'g1', title: '일반', link: '/g1', date: '2026-01-02'),
    ],
    pages: {
      'pageMetas': [
        {'page': 1}
      ],
      'searchOptions': {'searchColumn': null, 'searchWord': null},
    },
  );
}

Future<void> _flushEvents([int times = 40]) async {
  for (var i = 0; i < times; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('NoticeBoardBloc 유닛 테스트', () {
    late _FakeNoticeBoardRepository repository;
    late _FakeUserPreferencesRepository userPreferencesRepository;
    late _FakeSharedPrefsManager prefs;
    late NoticeBoardBloc bloc;

    setUp(() {
      repository = _FakeNoticeBoardRepository();
      userPreferencesRepository = _FakeUserPreferencesRepository();
      prefs = _FakeSharedPrefsManager();
      bloc = NoticeBoardBloc(
        getAbsoluteNoticesUseCase:
            GetAbsoluteNoticesUseCase(repository: repository),
        getRelativeNoticesUseCase:
            GetRelativeNoticesUseCase(repository: repository),
        getUserSettingValueByNoticeTypeUseCase:
            GetUserSettingValueByNoticeTypeUseCase(sharedPrefsManager: prefs),
        getUserPreferencesUseCase:
            GetUserPreferenceUseCase(repository: userPreferencesRepository),
      );
    });

    tearDown(() async {
      await bloc.close();
    });

    test('학과 탭 로드 시 설정값이 없으면 NoticeBoardSettingRequired 상태가 된다', () async {
      bloc.add(const LoadNoticeBoardEvent(noticeType: 'MAJOR'));
      await _flushEvents();

      expect(
        bloc.state,
        const NoticeBoardSettingRequired(
            noticeType: 'MAJOR', displayName: '학과'),
      );
    });

    test('전체공지 로드 성공 시 NoticeBoardLoaded 상태가 된다', () async {
      bloc.add(const LoadNoticeBoardEvent(noticeType: 'WHOLE'));
      await _flushEvents();

      expect(bloc.state, isA<NoticeBoardLoaded>());
      final loaded = bloc.state as NoticeBoardLoaded;
      expect(loaded.currentPage, 1);
      expect(loaded.isKeywordSearchable, isTrue);
      expect(repository.lastAbsoluteNoticeType, 'WHOLE');
    });

    test('도서관 로드 성공 시 relative 로딩으로 currentPage=1이 된다', () async {
      bloc.add(const LoadNoticeBoardEvent(noticeType: 'LIBRARY'));
      await _flushEvents();

      expect(bloc.state, isA<NoticeBoardLoaded>());
      final loaded = bloc.state as NoticeBoardLoaded;
      expect(loaded.currentPage, 1);
      expect(loaded.isKeywordSearchable, isFalse);
      expect(repository.lastRelativeNoticeType, 'LIBRARY');
      expect(repository.lastRelativeOffset, 0);
    });

    test('LoadPageEvent는 지정 페이지와 검색 조건으로 다시 조회한다', () async {
      bloc.add(const LoadNoticeBoardEvent(noticeType: 'WHOLE'));
      await _flushEvents();

      bloc.add(const LoadPageEvent(
          page: 3, searchColumn: 'title', searchWord: '장학'));
      await _flushEvents();

      final loaded = bloc.state as NoticeBoardLoaded;
      expect(loaded.currentPage, 3);
      expect(repository.lastAbsolutePage, 3);
      expect(repository.lastSearchColumn, 'title');
      expect(repository.lastSearchWord, '장학');
    });

    test('ToggleNoticeTypeEvent는 isHeadlineSelected를 변경한다', () async {
      bloc.add(const LoadNoticeBoardEvent(noticeType: 'WHOLE'));
      await _flushEvents();

      bloc.add(const ToggleNoticeTypeEvent(isHeadline: true));
      await _flushEvents();

      final loaded = bloc.state as NoticeBoardLoaded;
      expect(loaded.isHeadlineSelected, isTrue);
    });

    test('공지 조회 실패 시 NoticeBoardError 상태가 된다', () async {
      repository.absoluteResult =
          const Left(NoticeBoardFailure.fetchNotices('조회 실패'));

      bloc.add(const LoadNoticeBoardEvent(noticeType: 'WHOLE'));
      await _flushEvents();

      expect(bloc.state, const NoticeBoardError(message: '조회 실패'));
    });
  });
}
