/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:inha_notice/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:inha_notice/features/bookmark/data/models/bookmark_model.dart';
import 'package:inha_notice/features/custom_tab/domain/usecases/get_user_setting_value_by_notice_type_use_case.dart';
import 'package:inha_notice/features/notice/domain/entities/notice_board_entity.dart';
import 'package:inha_notice/features/notice/domain/failures/notice_board_failure.dart';
import 'package:inha_notice/features/notice/domain/repositories/notice_board_repository.dart';
import 'package:inha_notice/features/notice/domain/usecases/get_notices_use_case.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_bloc.dart';
import 'package:inha_notice/features/notice/presentation/bloc/notice_board_state.dart';
import 'package:inha_notice/features/notice/presentation/pages/notice_board_page.dart';
import 'package:inha_notice/features/notice/presentation/widgets/pagination_widget.dart';
import 'package:inha_notice/injection_container.dart' as di;

import '../../../support/widget_test_pump_app.dart';

class _FakeSharedPrefsManager extends SharedPrefsManager {
  _FakeSharedPrefsManager() : super(null);
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

class _FakeNoticeBoardRepository implements NoticeBoardRepository {
  @override
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchAbsoluteNotices({
    required String noticeType,
    required int page,
    String? searchColumn,
    String? searchWord,
  }) async {
    return Right(
      NoticeBoardEntity(
        headlineNotices: const [],
        generalNotices: const [],
        pages: createPages(),
      ),
    );
  }

  @override
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchRelativeNotices({
    required String noticeType,
    required int offset,
  }) async {
    return Right(
      NoticeBoardEntity(
        headlineNotices: const [],
        generalNotices: const [],
        pages: createPages(),
      ),
    );
  }
}

class _TestNoticeBoardBloc extends NoticeBoardBloc {
  _TestNoticeBoardBloc()
      : super(
          getAbsoluteNoticesUseCase: GetAbsoluteNoticesUseCase(
              repository: _FakeNoticeBoardRepository()),
          getRelativeNoticesUseCase: GetRelativeNoticesUseCase(
              repository: _FakeNoticeBoardRepository()),
          getUserSettingValueByNoticeTypeUseCase:
              GetUserSettingValueByNoticeTypeUseCase(
                  sharedPrefsManager: _FakeSharedPrefsManager()),
        );

  void setStateForTest(NoticeBoardState state) {
    emit(state);
  }
}

NoticeBoardLoaded _loadedState({
  bool isHeadlineSelected = false,
}) {
  return NoticeBoardLoaded(
    headlineNotices: const [
      NoticeTileModel(
        id: 'h1',
        title: '중요 공지',
        link: 'https://example.com/h',
        date: '2026-02-19',
      ),
    ],
    generalNotices: const [
      NoticeTileModel(
        id: 'g1',
        title: '일반 공지',
        link: 'https://example.com/g',
        date: '2026-02-19',
      ),
    ],
    pages: {
      'pageMetas': [
        {'page': 1, 'offset': 0},
        {'page': 2, 'offset': 10},
      ],
      'searchOptions': {
        'searchColumn': 'title',
        'searchWord': '공지',
      }
    },
    currentPage: 1,
    isHeadlineSelected: isHeadlineSelected,
    isKeywordSearchable: true,
    isRefreshing: false,
  );
}

void main() {
  group('NoticeBoardPage 위젯 테스트', () {
    late _TestNoticeBoardBloc bloc;

    setUp(() async {
      await di.sl.reset();
      di.sl.registerLazySingleton<BookmarkLocalDataSource>(
          () => _FakeBookmarkLocalDataSource());
      bloc = _TestNoticeBoardBloc();
    });

    tearDown(() async {
      await bloc.close();
      await di.sl.reset();
    });

    Future<void> _pumpNoticeBoard(WidgetTester tester) async {
      await pumpInhaApp(
        tester,
        wrapWithScaffold: false,
        child: BlocProvider<NoticeBoardBloc>.value(
          value: bloc,
          child: const NoticeBoardPage(noticeType: 'WHOLE'),
        ),
      );
      await tester.pump();
    }

    testWidgets('로딩된 상태에서 토글과 목록, 페이지네이션을 렌더링한다', (tester) async {
      await _pumpNoticeBoard(tester);
      bloc.setStateForTest(_loadedState());
      await tester.pump();

      expect(find.text('일반'), findsOneWidget);
      expect(find.text('중요'), findsOneWidget);
      expect(find.text('일반 공지'), findsOneWidget);
      expect(find.byType(PaginationWidget), findsOneWidget);
    });

    testWidgets('중요 선택 상태에서 중요 공지 목록을 렌더링한다', (tester) async {
      await _pumpNoticeBoard(tester);
      bloc.setStateForTest(_loadedState(isHeadlineSelected: true));
      await tester.pump();

      expect(find.text('중요 공지'), findsOneWidget);
      expect(find.text('일반 공지'), findsNothing);
    });

    testWidgets('설정 필요 상태에서 안내 UI를 렌더링한다', (tester) async {
      await _pumpNoticeBoard(tester);
      bloc.setStateForTest(
        const NoticeBoardSettingRequired(
            noticeType: 'MAJOR', displayName: '학과'),
      );
      await tester.pump();

      expect(find.text('학과를 설정해주세요!'), findsOneWidget);
      expect(find.text('학과 설정하기'), findsOneWidget);
    });

    testWidgets('에러 상태에서 빈 결과 안내 UI를 렌더링한다', (tester) async {
      await _pumpNoticeBoard(tester);
      bloc.setStateForTest(const NoticeBoardError(message: '로드 실패'));
      await tester.pump();

      expect(find.text('공지사항을 찾지 못했어요!'), findsOneWidget);
    });
  });
}
