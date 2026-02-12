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
import 'package:inha_notice/features/search/domain/entities/trending_topic_entity.dart';
import 'package:inha_notice/features/search/domain/failures/search_failure.dart';

abstract class SearchRepository {
  // 인기 검색어
  Future<Either<SearchFailure, List<TrendingTopicEntity>>> getTrendingTopics();

  // 최근 검색어
  Future<Either<SearchFailure, void>> addRecentSearchWord(String query);
  Future<Either<SearchFailure, void>> clearRecentSearchWords();
  List<String> getRecentSearchWords();
  Future<Either<SearchFailure, void>> removeRecentSearchWord(String query);
}
