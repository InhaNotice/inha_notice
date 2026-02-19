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
import 'package:inha_notice/core/error/failures.dart';
import 'package:inha_notice/features/notice/domain/entities/home_tab_entity.dart';
import 'package:inha_notice/features/notice/domain/entities/notice_board_entity.dart';
import 'package:inha_notice/features/notice/domain/failures/notice_board_failure.dart';
import 'package:inha_notice/features/notice/domain/repositories/home_repository.dart';
import 'package:inha_notice/features/notice/domain/repositories/notice_board_repository.dart';
import 'package:inha_notice/features/notice/domain/usecases/get_home_tabs_use_case.dart';
import 'package:inha_notice/features/notice/domain/usecases/get_notices_use_case.dart';

class _FakeNoticeBoardRepository implements NoticeBoardRepository {
  Either<NoticeBoardFailure, NoticeBoardEntity> absoluteResult =
      Right(const NoticeBoardEntity(
    headlineNotices: [],
    generalNotices: [],
    pages: {'pageMetas': [], 'searchOptions': {}},
  ));
  Either<NoticeBoardFailure, NoticeBoardEntity> relativeResult =
      Right(const NoticeBoardEntity(
    headlineNotices: [],
    generalNotices: [],
    pages: {'pageMetas': [], 'searchOptions': {}},
  ));

  String? lastNoticeType;
  int? lastPage;
  int? lastOffset;
  String? lastSearchColumn;
  String? lastSearchWord;

  @override
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchAbsoluteNotices({
    required String noticeType,
    required int page,
    String? searchColumn,
    String? searchWord,
  }) async {
    lastNoticeType = noticeType;
    lastPage = page;
    lastSearchColumn = searchColumn;
    lastSearchWord = searchWord;
    return absoluteResult;
  }

  @override
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchRelativeNotices({
    required String noticeType,
    required int offset,
  }) async {
    lastNoticeType = noticeType;
    lastOffset = offset;
    return relativeResult;
  }
}

class _FakeHomeRepository implements HomeRepository {
  Either<HomeFailure, List<HomeTabEntity>> result = const Right([]);

  @override
  Future<Either<HomeFailure, List<HomeTabEntity>>> getHomeTabs() async {
    return result;
  }
}

void main() {
  group('Notice UseCase 유닛 테스트', () {
    test('GetAbsoluteNoticesUseCase는 파라미터를 전달한다', () async {
      final repository = _FakeNoticeBoardRepository();
      final useCase = GetAbsoluteNoticesUseCase(repository: repository);

      final result = await useCase(
        noticeType: 'WHOLE',
        page: 2,
        searchColumn: 'title',
        searchWord: '장학',
      );

      expect(repository.lastNoticeType, 'WHOLE');
      expect(repository.lastPage, 2);
      expect(repository.lastSearchColumn, 'title');
      expect(repository.lastSearchWord, '장학');
      expect(result.isRight(), isTrue);
    });

    test('GetRelativeNoticesUseCase는 파라미터를 전달한다', () async {
      final repository = _FakeNoticeBoardRepository();
      final useCase = GetRelativeNoticesUseCase(repository: repository);

      final result = await useCase(noticeType: 'LIBRARY', offset: 20);

      expect(repository.lastNoticeType, 'LIBRARY');
      expect(repository.lastOffset, 20);
      expect(result.isRight(), isTrue);
    });

    test('GetHomeTabsUseCase는 저장소 결과를 그대로 반환한다', () async {
      final repository = _FakeHomeRepository()
        ..result = const Right([
          HomeTabEntity(noticeType: 'WHOLE', label: '학사'),
        ]);
      final useCase = GetHomeTabsUseCase(repository);

      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Right 이어야 합니다.'),
        (tabs) => expect(tabs.first.noticeType, 'WHOLE'),
      );
    });
  });
}
