import 'dart:async';

import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// **ReadNoticeManager**
/// 이 클래스는 읽은 공지사항을 관리하는 데이터베이스를 정의하는 클래스입니다.
class ReadNoticeManager {
  static const String tableName = 'read_notices';
  static Database? _database;
  static final logger = Logger();

  // 읽은 공지사항 캐싱 (Set으로 유지)
  static Set<String> _cachedReadNoticeIds = {};

  /// **SQLite 초기화 + 캐싱 로드**
  static Future<void> initialize() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, 'read_notices.db');

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE $tableName (id TEXT PRIMARY KEY)',
          );
        },
      );

      // 데이터베이스 초기화 후 캐시 업데이트
      await _loadCachedReadNotices();
    } catch (e) {
      logger.e('ReadNoticeManager - initialize() 오류: $e');
    }
  }

  /// **데이터베이스 가져오기 (최적화)**
  static Future<Database> _getDatabase() async {
    if (_database == null) {
      await initialize();
    }
    return _database!;
  }

  /// **DB에서 읽은 공지 목록 불러와 캐싱**
  static Future<void> _loadCachedReadNotices() async {
    try {
      final db = await _getDatabase();
      final result = await db.query(tableName);
      _cachedReadNoticeIds = result.map((row) => row['id'] as String).toSet();
    } catch (e) {
      logger.e('ReadNoticeManager - _loadCachedReadNotices() 오류: $e');
    }
  }

  /// **📌 읽은 공지사항 로드 (캐싱 활용)**
  static Set<String> getReadNoticeIds() {
    return _cachedReadNoticeIds;
  }

  /// **📌 읽은 공지사항 추가 (캐싱 및 DB 반영)**
  static Future<void> addReadNotice(String noticeId) async {
    if (_cachedReadNoticeIds.contains(noticeId)) return; // 중복 방지

    try {
      final db = await _getDatabase();
      await db.insert(
        tableName,
        {'id': noticeId},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );

      // ✅ 캐싱 업데이트
      _cachedReadNoticeIds.add(noticeId);
    } catch (e) {
      print("🚨 Error adding read notice: $e");
    }
  }

  /// **📌 특정 읽은 공지사항 삭제 (캐싱 및 DB 반영)**
  static Future<void> removeReadNotice(String noticeId) async {
    if (!_cachedReadNoticeIds.contains(noticeId)) return; // 존재하지 않으면 패스

    try {
      final db = await _getDatabase();
      await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [noticeId],
      );

      // ✅ 캐싱 업데이트
      _cachedReadNoticeIds.remove(noticeId);
    } catch (e) {
      print("🚨 Error removing read notice: $e");
    }
  }

  static bool isReadNotice(String noticeId) {
    return _cachedReadNoticeIds.contains(noticeId);
  }
}
