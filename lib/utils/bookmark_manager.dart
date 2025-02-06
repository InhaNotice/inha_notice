import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BookmarkManager {
  static const String tableName = 'bookmarks';
  static Database? _database;

  // 북마크 캐싱 (Set으로 유지)
  static Set<String> _cachedBookmarks = {};

  /// 데이터베이스 초기화
  static Future<void> initDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'bookmarks.db');

      _database = await openDatabase(
        path,
        version: 1,
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
      print("🚨 Database Initialization Error: $e");
    }
  }

  /// 데이터베이스 가져오기 (최적화)
  static Future<Database> _getDatabase() async {
    if (_database == null) {
      await initDatabase();
    }
    return _database!;
  }

  /// **📌 DB에서 북마크 목록 불러와 캐싱**
  static Future<void> _loadCachedBookmarks() async {
    try {
      final db = await _getDatabase();
      final result = await db.query(tableName, columns: ['id']);
      _cachedBookmarks = result.map((row) => row['id'] as String).toSet();
    } catch (e) {
      print("🚨 Error loading cached bookmarks: $e");
    }
  }

  /// **📌 모든 북마크 ID 가져오기 (캐싱)**
  static Set<String> getBookmarkIds() {
    return _cachedBookmarks;
  }

  /// **📌 북마크 추가 (캐싱 활용)**
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
      print("🚨 Error adding bookmark: $e");
    }
  }

  /// **📌 북마크 제거 (캐싱 활용)**
  static Future<void> removeBookmark(String noticeId) async {
    try {
      final db = await _getDatabase();
      await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [noticeId],
      );

      // 캐싱에서 제거
      _cachedBookmarks.remove(noticeId);
    } catch (e) {
      print("🚨 Error removing bookmark: $e");
    }
  }

  /// **📌 북마크 여부 확인 (캐싱 활용)**
  static bool isBookmarked(String noticeId) {
    return _cachedBookmarks.contains(noticeId);
  }

  /// **📌 모든 북마크 데이터 가져오기 (자세한 정보 포함)**
  static Future<List<Map<String, dynamic>>> getAllBookmarks() async {
    try {
      final db = await _getDatabase();
      final result = await db.query(tableName);
      return result;
    } catch (e) {
      print("🚨 Error fetching bookmark details: $e");
      return [];
    }
  }
}
