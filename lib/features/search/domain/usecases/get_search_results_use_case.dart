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
import 'package:inha_notice/features/search/domain/repositories/search_result_repository.dart';

/// **GetSearchResultsUseCase**
/// 검색 결과를 가져오는 UseCase입니다.
class GetSearchResultsUseCase {
  final SearchResultRepository repository;

  const GetSearchResultsUseCase({required this.repository});

  Future<Either<SearchFailure, SearchResultEntity>> call({
    required String query,
    required int offset,
    required String sortedType,
  }) async {
    return await repository.fetchSearchResults(
      query: query,
      offset: offset,
      sortedType: sortedType,
    );
  }
}
