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
import 'package:inha_notice/features/search/domain/repositories/search_result_repository.dart';

class SearchNoticesUseCase {
  final SearchResultRepository repository;

  SearchNoticesUseCase({required this.repository});

  Future<Either<SearchResultFailure, SearchResultEntity>> call({
    required String query,
    required int startCount,
    required String sortType,
  }) async {
    return await repository.searchNotices(
      query: query,
      startCount: startCount,
      sortType: sortType,
    );
  }
}
