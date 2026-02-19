/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:inha_notice/features/search/data/datasources/recent_search_local_data_source.dart';

abstract class SearchLocalDataSource {
  Future<void> initialize();

  List<String> getRecentSearchWords();

  Future<void> addRecentSearchWord(String query);

  Future<void> removeRecentSearchWord(String query);

  Future<void> clearRecentSearchWords();
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final RecentSearchLocalDataSource recentSearchManager;

  SearchLocalDataSourceImpl({required this.recentSearchManager});

  @override
  Future<void> initialize() async {
    await recentSearchManager.initialize();
  }

  @override
  List<String> getRecentSearchWords() {
    return recentSearchManager.getRecentSearchTopics();
  }

  @override
  Future<void> addRecentSearchWord(String query) async {
    await recentSearchManager.addRecentSearch(query);
  }

  @override
  Future<void> removeRecentSearchWord(String query) async {
    await recentSearchManager.removeRecentSearch(query);
  }

  @override
  Future<void> clearRecentSearchWords() async {
    await recentSearchManager.clearSearchHistory();
  }
}
