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

/// **NoticeBoardRepository**
/// 공지사항 게시판의 데이터 접근 계약을 정의하는 추상 인터페이스입니다.
abstract class NoticeBoardRepository {
  /// Absolute 스타일 공지사항을 가져옵니다.
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchAbsoluteNotices({
    required String noticeType,
    required int page,
    String? searchColumn,
    String? searchWord,
  });

  /// Relative 스타일 공지사항을 가져옵니다.
  Future<Either<NoticeBoardFailure, NoticeBoardEntity>> fetchRelativeNotices({
    required String noticeType,
    required int offset,
  });
}
