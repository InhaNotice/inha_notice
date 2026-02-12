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
import 'package:inha_notice/features/search/data/datasources/search_local_data_source.dart';
import 'package:inha_notice/features/search/data/datasources/search_remote_data_source.dart';
import 'package:inha_notice/features/search/domain/entities/trending_topic_entity.dart';
import 'package:inha_notice/features/search/domain/failures/search_failure.dart';
import 'package:inha_notice/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;

  SearchRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  // 인기 검색어
  @override
  Future<Either<SearchFailure, List<TrendingTopicEntity>>>
      getTrendingTopics() async {
    try {
      final List<TrendingTopicEntity> result =
          await remoteDataSource.getTrendingTopics();
      return Right(result);
    } catch (e) {
      return Left(SearchFailure.server());
    }
  }

  // 최근 검색어
  @override
  Future<Either<SearchFailure, void>> addRecentSearchWord(String query) async {
    try {
      await localDataSource.addRecentSearchWord(query);
      return Right(null);
    } catch (e) {
      return Left(SearchFailure.localDatabase());
    }
  }

  @override
  Future<Either<SearchFailure, void>> clearRecentSearchWords() async {
    try {
      await localDataSource.clearRecentSearchWords();
      return Right(null);
    } catch (e) {
      return Left(SearchFailure.localDatabase());
    }
  }

  @override
  List<String> getRecentSearchWords() {
    return localDataSource.getRecentSearchWords();
  }

  @override
  Future<Either<SearchFailure, void>> removeRecentSearchWord(
      String query) async {
    try {
      await localDataSource.removeRecentSearchWord(query);
      return Right(null);
    } catch (e) {
      return Left(SearchFailure.localDatabase());
    }
  }
}
