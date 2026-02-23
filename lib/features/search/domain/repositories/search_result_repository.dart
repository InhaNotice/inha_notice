/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-23
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/search/domain/entities/search_result_entity.dart';
import 'package:inha_notice/features/search/domain/failures/search_failure.dart';

/// **SearchResultRepository**
/// 검색 결과 데이터 접근 계약을 정의하는 추상 인터페이스입니다.
abstract class SearchResultRepository {
  Future<Either<SearchFailure, SearchResultEntity>> fetchSearchResults({
    required String query,
    required int offset,
    required String sortedType,
  });
}
