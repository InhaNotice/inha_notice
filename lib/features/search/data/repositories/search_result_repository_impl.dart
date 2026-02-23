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
import 'package:inha_notice/features/search/data/datasources/search_result_remote_data_source.dart';
import 'package:inha_notice/features/search/data/models/search_result_model.dart';
import 'package:inha_notice/features/search/domain/entities/search_result_entity.dart';
import 'package:inha_notice/features/search/domain/failures/search_failure.dart';
import 'package:inha_notice/features/search/domain/repositories/search_result_repository.dart';

/// **SearchResultRepositoryImpl**
/// SearchResultRepository의 구현체입니다.
class SearchResultRepositoryImpl implements SearchResultRepository {
  final SearchResultRemoteDataSource remoteDataSource;

  const SearchResultRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<SearchFailure, SearchResultEntity>> fetchSearchResults({
    required String query,
    required int offset,
    required String sortedType,
  }) async {
    try {
      final SearchResultModel result =
          await remoteDataSource.fetchSearchResults(
        query: query,
        offset: offset,
        sortedType: sortedType,
      );
      return Right(result);
    } catch (e) {
      return Left(SearchFailure.fetchResults(e.toString()));
    }
  }
}
