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
import 'package:inha_notice/features/search/domain/entities/search_result_entity.dart';
import 'package:inha_notice/features/search/domain/failures/search_result_failure.dart';

abstract class SearchResultRepository {
  /// 검색어로 공지사항을 검색한다.
  ///
  /// [query] 검색어
  /// [startCount] 시작 오프셋 (페이지네이션)
  /// [sortType] 정렬 타입 ('RANK' 또는 'DATE')
  Future<Either<SearchResultFailure, SearchResultEntity>> searchNotices({
    required String query,
    required int startCount,
    required String sortType,
  });
}
