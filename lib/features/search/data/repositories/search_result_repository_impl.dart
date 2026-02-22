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
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/features/search/data/datasources/search_scraper.dart';
import 'package:inha_notice/features/search/domain/entities/search_result_entity.dart';
import 'package:inha_notice/features/search/domain/failures/search_result_failure.dart';
import 'package:inha_notice/features/search/domain/repositories/search_result_repository.dart';

class SearchResultRepositoryImpl implements SearchResultRepository {
  final SearchDataSource dataSource;

  SearchResultRepositoryImpl({required this.dataSource});

  @override
  Future<Either<SearchResultFailure, SearchResultEntity>> searchNotices({
    required String query,
    required int startCount,
    required String sortType,
  }) async {
    try {
      final result = await dataSource.fetchNotices(query, startCount, sortType);

      final noticesData = result['general'] as List<dynamic>;
      final notices = noticesData
          .map((notice) =>
              NoticeTileModel.fromMap(notice as Map<String, dynamic>))
          .toList();

      final pagesData = result['pages'] as Map<String, dynamic>;
      final pages = Pages.from(pagesData);

      return Right(SearchResultEntity(notices: notices, pages: pages));
    } catch (e) {
      return Left(SearchResultFailure.network(e.toString()));
    }
  }
}
