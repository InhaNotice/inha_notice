import 'dart:async';

import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class RecentSearchTopicsManager {
  static const String tableName = 'recent_search_topics';
  static Database? _database;
  static const int _maxHistoryCount = 10;
  static final Logger _logger = Logger();

  // 최근 검색어 캐시
  static List<String> _cachedRecentSearchTopics = [];

  /// **SQLite 초기화 + 캐시 로드**
  static Future<void> initialize() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, '$tableName.db');

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              topic TEXT NOT NULL UNIQUE
            )
          ''');
        },
      );

      // DB 초기화 후 캐시 업데이트
      await _loadCachedRecentSearchTopics();
    } catch (e) {
      _logger.e('RecentSearchTopicsManager - initialize() 오류: $e');
    }
  }

  /// **데이터베이스 가져오기**
  static Future<Database> _getDatabase() async {
    if (_database == null) {
      await initialize();
    }
    return _database!;
  }

  /// **DB에서 최근 검색어 불러와 캐싱 (최신순)**
  static Future<void> _loadCachedRecentSearchTopics() async {
    try {
      final db = await _getDatabase();
      final result = await db.query(
        tableName,
        columns: ['topic'],
        orderBy: 'id DESC', // 최신순 정렬
      );
      _cachedRecentSearchTopics =
          result.map((row) => row['topic'] as String).toList();
    } catch (e) {
      _logger.e(
          'RecentSearchTopicsManager - _loadCachedRecentSearchTopics() 오류: $e');
    }
  }

  /// **모든 최근 검색어 가져오기 (최신순)**
  static List<String> getRecentSearchTopics() {
    return List.from(_cachedRecentSearchTopics); // 불변 리스트 반환
  }

  /// **검색어 추가 (최신순 유지)**
  static Future<void> addTopic(String query) async {
    try {
      final db = await _getDatabase();

      // 같은 검색어가 있으면 최신으로 갱신
      await db.insert(
        tableName,
        {'topic': query},
        conflictAlgorithm: ConflictAlgorithm.replace, // 중복된 검색어는 갱신됨
      );

      // 캐시 업데이트
      await _loadCachedRecentSearchTopics();

      // 최대 개수 초과 시 가장 오래된 검색어 삭제
      if (_cachedRecentSearchTopics.length > _maxHistoryCount) {
        await _removeOldestTopic();
      }
    } catch (e) {
      _logger.e('RecentSearchTopicsManager - addTopic() 오류: $e');
    }
  }

  /// **가장 오래된 검색어 삭제**
  static Future<void> _removeOldestTopic() async {
    try {
      final db = await _getDatabase();
      final result = await db.query(
        tableName,
        columns: ['id'],
        orderBy: 'id ASC',
        limit: 1,
      );

      if (result.isNotEmpty) {
        final int oldestId = result.first['id'] as int;
        await db.delete(tableName, where: 'id = ?', whereArgs: [oldestId]);
        await _loadCachedRecentSearchTopics(); // 캐시 갱신
      }
    } catch (e) {
      _logger.e('RecentSearchTopicsManager - _removeOldestTopic() 오류: $e');
    }
  }

  /// **최근 검색어 제거**
  static Future<void> removeTopic(String query) async {
    try {
      final db = await _getDatabase();
      await db.delete(
        tableName,
        where: 'topic = ?',
        whereArgs: [query],
      );

      // 캐시 갱신
      await _loadCachedRecentSearchTopics();
    } catch (e) {
      _logger.e('RecentSearchTopicsManager - removeTopic() 오류: $e');
    }
  }

  /// **검색 기록 전체 삭제**
  static Future<void> clearSearchHistory() async {
    try {
      final db = await _getDatabase();
      await db.delete(tableName);
      _cachedRecentSearchTopics.clear();
    } catch (e) {
      _logger.e('RecentSearchTopicsManager - clearSearchHistory() 오류: $e');
    }
  }
}
