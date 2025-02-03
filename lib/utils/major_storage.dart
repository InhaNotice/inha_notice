import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MajorStorage {
  static final Logger logger = Logger();
  static const String _databaseName = 'major_database.db';
  static const String _tableName = 'selected_major';
  static const int _databaseVersion = 1;

  static Database? _database;
  static String? _cachedMajor;

  // Initialize the database
  static Future<void> initDatabase() async {
    if (_database != null) return;

    String dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            major TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Save selected major
  static Future<void> saveMajor(String major) async {
    _cachedMajor = major;
    await _database?.delete(_tableName); // Clear existing data
    await _database?.insert(
      _tableName,
      {'major': major},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    logger.d('✅ 새로운 학과 저장 성공!');
  }

  // Get the saved major
  static Future<String?> getMajor() async {
    if (_database == null) {
      initDatabase();
    }
    if (_cachedMajor != null) {
      // 캐싱된 값이 있다면 반환
      return _cachedMajor;
    }
    List<Map<String, dynamic>>? results = await _database?.query(_tableName);
    if (results != null && results.isNotEmpty) {
      return results.first['major'] as String;
    }
    return null;
  }
}
