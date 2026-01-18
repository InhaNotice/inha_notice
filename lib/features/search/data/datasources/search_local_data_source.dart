/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-19
 */

import 'package:inha_notice/utils/recent_search/recent_search_manager.dart';

/// 최근 검색어(SharedPreferences)를 담당
/// static 메서드인 RecentSearchManager를 감싸서 주입 가능하게 만듦
abstract class SearchLocalDataSource {
  List<String> getRecentSearchWords();

  Future<void> addRecentSearchWord(String query);

  Future<void> removeRecentSearchWord(String query);

  Future<void> clearRecentSearchWords();
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  @override
  List<String> getRecentSearchWords() {
    return RecentSearchManager.getRecentSearchTopics();
  }

  @override
  Future<void> addRecentSearchWord(String query) async {
    await RecentSearchManager.addRecentSearch(query);
  }

  @override
  Future<void> removeRecentSearchWord(String query) async {
    await RecentSearchManager.removeRecentSearch(query);
  }

  @override
  Future<void> clearRecentSearchWords() async {
    await RecentSearchManager.clearSearchHistory();
  }
}
