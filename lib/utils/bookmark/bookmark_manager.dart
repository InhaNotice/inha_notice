/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-23
 */

import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// **BookmarkManager**
/// 이 클래스는 북마크된 공지사항을 관리하는 데이터베이스를 정의하는 클래스입니다.
class BookmarkManager {
  static const String tableName = 'bookmarks';
  static Database? _database;
  static final logger = Logger();

  // 북마크 캐싱 (Set으로 유지)
  static Set<String> _cachedBookmarks = {};

  /// **데이터베이스 초기화**
  static Future<void> initialize() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'notice_bookmarks.db');

      _database = await openDatabase(
        path,
        version: 2,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $tableName (
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              link TEXT NOT NULL,
              date TEXT NOT NULL
            )
          ''');
        },
      );

      // DB 초기화 후 캐시 업데이트
      await _loadCachedBookmarks();
    } catch (e) {
      logger.e('BookmarkManager - initialize() 오류: $e');
    }
  }

  /// **데이터베이스 가져오기 (최적화)**
  static Future<Database> _getDatabase() async {
    if (_database == null) {
      await initialize();
    }
    return _database!;
  }

  /// **DB에서 북마크 목록 불러와 캐싱**
  static Future<void> _loadCachedBookmarks() async {
    try {
      final db = await _getDatabase();
      final result = await db.query(tableName, columns: ['id']);
      _cachedBookmarks = result.map((row) => row['id'] as String).toSet();
    } catch (e) {
      logger.e('BookmarkManager - _loadCachedBookmarks() 오류: $e');
    }
  }

  /// **모든 북마크 ID 가져오기 (캐싱)**
  static Set<String> getBookmarkIds() {
    return _cachedBookmarks;
  }

  /// **북마크 추가 (캐싱 활용)**
  static Future<void> addBookmark(Map<String, dynamic> notice) async {
    try {
      final db = await _getDatabase();

      // **DB에 저장할 필드만 추출**
      final bookmarkData = {
        'id': notice['id'],
        'title': notice['title'],
        'link': notice['link'],
        'date': notice['date'],
      };

      await db.insert(
        tableName,
        bookmarkData,
        conflictAlgorithm: ConflictAlgorithm.ignore, // 중복 방지
      );

      // 캐싱 업데이트
      _cachedBookmarks.add(notice['id']);
    } catch (e) {
      logger.e('BookmarkManager - addBookmark() 오류: $e');
    }
  }

  /// **북마크 제거 (캐싱 활용)**
  static Future<void> removeBookmark(String noticeId) async {
    try {
      final db = await _getDatabase();
      await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [noticeId],
      );
      _cachedBookmarks.remove(noticeId);
    } catch (e) {
      logger.e('BookmarkManager - removeBookmark() 오류: $e');
    }
  }

  /// **북마크 여부 확인 (캐싱 활용)**
  static bool isBookmarked(String noticeId) {
    return _cachedBookmarks.contains(noticeId);
  }

  /// **모든 북마크 데이터 가져오기 (자세한 정보 포함)**
  static Future<List<Map<String, dynamic>>> getAllBookmarks() async {
    try {
      final db = await _getDatabase();
      final result = await db.query(tableName);
      return result;
    } catch (e) {
      logger.e('BookmarkManager - getAllBookmarks() 오류: $e');
      return [];
    }
  }

  /// **모든 북마크 삭제**
  static Future<void> clearAllBookmarks() async {
    try {
      final db = await _getDatabase();
      // 데이터베이스 삭제
      await db.delete(tableName);
      // 캐시 비우기
      _cachedBookmarks.clear();
      logger.d('✅ clearAllBookmarks() 성공: 모든 북마크 삭제 완료');
    } catch (e) {
      logger.e('❌ clearAllBookmarks() 오류: $e');
    }
  }
}
