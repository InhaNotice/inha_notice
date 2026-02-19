/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/search/data/datasources/recent_search_local_data_source.dart';
import 'package:logger/logger.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _FakePathProviderPlatform extends PathProviderPlatform {
  final String documentsPath;

  _FakePathProviderPlatform(this.documentsPath);

  @override
  Future<String?> getApplicationDocumentsPath() async => documentsPath;
}

Logger _testLogger() {
  return Logger(
    printer: PrettyPrinter(methodCount: 0, colors: false, printEmojis: false),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RecentSearchLocalDataSourceImpl 유닛 테스트', () {
    late PathProviderPlatform originalPathProvider;
    final tempDirs = <Directory>[];

    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    setUp(() {
      originalPathProvider = PathProviderPlatform.instance;
    });

    tearDown(() async {
      PathProviderPlatform.instance = originalPathProvider;
      for (final dir in tempDirs) {
        if (await dir.exists()) {
          await dir.delete(recursive: true);
        }
      }
      tempDirs.clear();
    });

    Future<RecentSearchLocalDataSourceImpl> createManager() async {
      final dir = await Directory.systemTemp.createTemp('recent_search_test_');
      tempDirs.add(dir);
      PathProviderPlatform.instance = _FakePathProviderPlatform(dir.path);

      final manager = RecentSearchLocalDataSourceImpl(logger: _testLogger());
      await manager.initialize();
      return manager;
    }

    test('initialize 직후 최근 검색어 목록은 비어있다', () async {
      final manager = await createManager();

      expect(manager.getRecentSearchTopics(), isEmpty);
      expect(manager.isCachedSearchHistory(), isFalse);
    });

    test('addRecentSearch는 최신 검색어를 앞에 유지한다', () async {
      final manager = await createManager();

      await manager.addRecentSearch('학사');
      await manager.addRecentSearch('장학');

      expect(manager.getRecentSearchTopics(), ['장학', '학사']);
      expect(manager.isCachedSearchHistory(), isTrue);
    });

    test('addRecentSearch는 중복 검색어를 최신 순서로 갱신한다', () async {
      final manager = await createManager();

      await manager.addRecentSearch('학사');
      await manager.addRecentSearch('장학');
      await manager.addRecentSearch('학사');

      expect(manager.getRecentSearchTopics(), ['학사', '장학']);
    });

    test('최근 검색어는 최대 10개까지만 유지한다', () async {
      final manager = await createManager();

      for (var i = 1; i <= 11; i++) {
        await manager.addRecentSearch('검색어$i');
      }

      final topics = manager.getRecentSearchTopics();
      expect(topics.length, 10);
      expect(topics.first, '검색어11');
      expect(topics.contains('검색어1'), isFalse);
    });

    test('removeRecentSearch는 해당 검색어를 제거한다', () async {
      final manager = await createManager();

      await manager.addRecentSearch('학사');
      await manager.addRecentSearch('장학');
      await manager.removeRecentSearch('학사');

      expect(manager.getRecentSearchTopics(), ['장학']);
    });

    test('clearSearchHistory는 모든 검색 기록을 비운다', () async {
      final manager = await createManager();

      await manager.addRecentSearch('학사');
      await manager.addRecentSearch('장학');
      await manager.clearSearchHistory();

      expect(manager.getRecentSearchTopics(), isEmpty);
      expect(manager.isCachedSearchHistory(), isFalse);
    });
  });
}
