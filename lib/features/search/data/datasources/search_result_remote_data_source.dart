/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-23
 */

import 'package:inha_notice/features/search/data/datasources/search_scraper.dart';
import 'package:inha_notice/features/search/data/models/search_result_model.dart';

/// **SearchResultRemoteDataSource**
/// 검색 결과 원격 데이터 소스 인터페이스입니다.
abstract class SearchResultRemoteDataSource {
  Future<SearchResultModel> fetchSearchResults({
    required String query,
    required int offset,
    required String sortedType,
  });
}

/// **SearchResultRemoteDataSourceImpl**
/// SearchScraper를 래핑하여 검색 결과를 가져오는 구현체입니다.
class SearchResultRemoteDataSourceImpl implements SearchResultRemoteDataSource {
  final SearchScraper _scraper;

  SearchResultRemoteDataSourceImpl({SearchScraper? scraper})
      : _scraper = scraper ?? SearchScraper();

  @override
  Future<SearchResultModel> fetchSearchResults({
    required String query,
    required int offset,
    required String sortedType,
  }) async {
    final Map<String, dynamic> result =
        await _scraper.fetchNotices(query, offset, sortedType);
    return SearchResultModel.fromRaw(result);
  }
}
