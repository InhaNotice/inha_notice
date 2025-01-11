import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ReadNoticeManager {
  static const String tableName = 'read_notices';
  static Database? _database;

  // SQLite 초기화
  static Future<Database> _initDatabase() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, 'read_notices.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE $tableName (id TEXT PRIMARY KEY)',
          );
        },
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow; // 에러를 다시 던져 상위에서 처리할 수 있도록
    }
  }

  static Future<Database> getDatabase() async {
    try {
      if (_database != null) return _database!;
      _database = await _initDatabase();
      return _database!;
    } catch (e) {
      print('Error getting database: $e');
      rethrow;
    }
  }

  // 읽은 공지사항 로드
  static Future<Set<String>> loadReadNotices() async {
    try {
      final db = await getDatabase();
      final result = await db.query(tableName);
      return result.map((row) => row['id'] as String).toSet();
    } catch (e) {
      print('Error loading read notices: $e');
      return {}; // 에러 발생 시 빈 Set 반환
    }
  }

  // 읽은 공지사항 저장
  static Future<void> saveReadNotices(Set<String> readIds) async {
    try {
      final db = await getDatabase();
      final batch = db.batch();

      // 기존 데이터 삭제
      await db.delete(tableName);

      // 새로운 데이터 삽입
      for (final id in readIds) {
        batch.insert(tableName, {'id': id});
      }
      await batch.commit(noResult: true);
    } catch (e) {
      print('Error saving read notices: $e');
    }
  }
}