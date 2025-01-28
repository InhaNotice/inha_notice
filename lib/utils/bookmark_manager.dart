import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookmarkManager {
  static Database? _database;

  // 데이터베이스 초기화
  static Future<void> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'bookmarks.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bookmarks (
            id TEXT PRIMARY KEY
          )
        ''');
      },
    );
  }

  // 데이터베이스 가져오기
  static Future<Database> _getDatabase() async {
    if (_database == null) {
      await _initDatabase();
    }
    return _database!;
  }

  // 북마크 추가
  static Future<void> addBookmark(String noticeId) async {
    final db = await _getDatabase();
    await db.insert(
      'bookmarks',
      {'id': noticeId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // 북마크 제거
  static Future<void> removeBookmark(String noticeId) async {
    final db = await _getDatabase();
    await db.delete(
      'bookmarks',
      where: 'id = ?',
      whereArgs: [noticeId],
    );
  }

  // 북마크 여부 확인
  static Future<bool> isBookmarked(String noticeId) async {
    final db = await _getDatabase();
    final result = await db.query(
      'bookmarks',
      where: 'id = ?',
      whereArgs: [noticeId],
    );
    return result.isNotEmpty;
  }

  // 모든 북마크 가져오기
  static Future<Set<String>> getAllBookmarks() async {
    final db = await _getDatabase();
    final result = await db.query('bookmarks');
    return result.map((row) => row['id'] as String).toSet();
  }
}
