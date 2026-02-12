/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/notice/domain/entities/notice_board_entity.dart';
import 'package:inha_notice/features/notice/domain/failures/notice_board_failure.dart';
import 'package:inha_notice/features/notice/domain/repositories/notice_board_repository.dart';

/// **GetAbsoluteNoticesUseCase**
/// Absolute 스타일 공지사항을 가져오는 UseCase입니다.
class GetAbsoluteNoticesUseCase {
  final NoticeBoardRepository repository;

  const GetAbsoluteNoticesUseCase({required this.repository});

  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> call({
    required String noticeType,
    required int page,
    String? searchColumn,
    String? searchWord,
  }) async {
    return await repository.fetchAbsoluteNotices(
      noticeType: noticeType,
      page: page,
      searchColumn: searchColumn,
      searchWord: searchWord,
    );
  }
}

/// **GetRelativeNoticesUseCase**
/// Relative 스타일 공지사항을 가져오는 UseCase입니다.
class GetRelativeNoticesUseCase {
  final NoticeBoardRepository repository;

  const GetRelativeNoticesUseCase({required this.repository});

  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> call({
    required String noticeType,
    required int offset,
  }) async {
    return await repository.fetchRelativeNotices(
      noticeType: noticeType,
      offset: offset,
    );
  }
}
