/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/search/data/datasources/recent_search_local_data_source.dart';
import 'package:inha_notice/features/search/data/datasources/search_local_data_source.dart';

class _FakeRecentSearchManager implements RecentSearchLocalDataSource {
  List<String> topics = [];
  String? addedQuery;
  String? removedQuery;
  bool isCleared = false;
  bool initialized = false;

  @override
  Future<void> initialize() async {
    initialized = true;
  }

  @override
  Future<void> addRecentSearch(String query) async {
    addedQuery = query;
  }

  @override
  Future<void> clearSearchHistory() async {
    isCleared = true;
  }

  @override
  List<String> getRecentSearchTopics() {
    return List.from(topics);
  }

  @override
  Future<void> removeRecentSearch(String query) async {
    removedQuery = query;
  }

  @override
  bool isCachedSearchHistory() {
    return topics.isNotEmpty;
  }
}

void main() {
  group('SearchLocalDataSourceImpl 유닛 테스트', () {
    test('initialize는 manager.initialize를 호출한다', () async {
      final manager = _FakeRecentSearchManager();
      final dataSource =
          SearchLocalDataSourceImpl(recentSearchManager: manager);

      await dataSource.initialize();

      expect(manager.initialized, isTrue);
    });

    test('getRecentSearchWords는 manager 값을 반환한다', () {
      final manager = _FakeRecentSearchManager()..topics = ['학사', '장학'];
      final dataSource =
          SearchLocalDataSourceImpl(recentSearchManager: manager);

      final result = dataSource.getRecentSearchWords();

      expect(result, ['학사', '장학']);
    });

    test('addRecentSearchWord는 manager.addRecentSearch를 호출한다', () async {
      final manager = _FakeRecentSearchManager();
      final dataSource =
          SearchLocalDataSourceImpl(recentSearchManager: manager);

      await dataSource.addRecentSearchWord('모집');

      expect(manager.addedQuery, '모집');
    });

    test('removeRecentSearchWord는 manager.removeRecentSearch를 호출한다', () async {
      final manager = _FakeRecentSearchManager();
      final dataSource =
          SearchLocalDataSourceImpl(recentSearchManager: manager);

      await dataSource.removeRecentSearchWord('정석');

      expect(manager.removedQuery, '정석');
    });

    test('clearRecentSearchWords는 manager.clearSearchHistory를 호출한다', () async {
      final manager = _FakeRecentSearchManager();
      final dataSource =
          SearchLocalDataSourceImpl(recentSearchManager: manager);

      await dataSource.clearRecentSearchWords();

      expect(manager.isCleared, isTrue);
    });
  });
}
