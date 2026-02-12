/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:inha_notice/core/error/exceptions.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/utils/app_logger.dart';
import 'package:inha_notice/features/bookmark/data/models/bookmark_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// 북마크를 관리하는 로컬 데이터 소스이다.
abstract class BookmarkLocalDataSource {
  Future<void> initialize();

  Future<BookmarkModel> getBookmarks();

  Future<void> addBookmark(NoticeTileModel notice);

  Future<void> removeBookmark(String noticeId);

  Future<void> clearBookmarks();

  bool isBookmarked(String noticeId);

  Set<String> getBookmarkIds();
}

/// 북마크를 관리하는 로컬 데이터 소스를 구현한다.
///
/// 데이터베이스를 초기화하여 [_database]로 불러오고,
/// 북마크 ID를 캐싱[_bookmarkIds]하여 관리한다.
class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  static const String databaseName = 'notice_bookmarks.db';
  static const String tableName = 'bookmarks';

  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colLink = 'link';
  static const String colDate = 'date';

  static const String createTableQuery = '''
          CREATE TABLE $tableName (
            $colId TEXT PRIMARY KEY,
            $colTitle TEXT NOT NULL,
            $colLink TEXT NOT NULL,
            $colDate TEXT NOT NULL
          )
        ''';

  /// 북마크 데이터베이스를 정의한다.
  Database? _database;

  /// 캐싱된 북마크
  Set<String> _bookmarkIds = {};

  /// 초기화 중복 실행 방지를 위한 Future
  Future<void>? _initializeFuture;

  /// 데이터베이스를 초기화하고 캐시를 업데이트한다.
  @override
  Future<void> initialize() async {
    // 이미 초기화가 진행 중이거나 완료되었다면 그 결과를 반환 (Memoization)
    if (_database != null) return;
    _initializeFuture ??= _initializeDatabase();
    await _initializeFuture;
  }

  /// 데이터베이스[_database]를 초기화하고 [_refreshCache]를 호출하여 캐시를 업데이트한다.
  Future<void> _initializeDatabase() async {
    try {
      final String databasePath = await getDatabasesPath();
      final String path = join(databasePath, databaseName);

      _database = await openDatabase(
        path,
        version: 2,
        onCreate: (db, version) async {
          await db.execute(createTableQuery);
        },
      );

      // DB 초기화 직후 캐시 동기화
      await _refreshCache();
    } on PlatformException catch (e) {
      throw LocalDatabaseException('기기 저장소 설정 중 플랫폼 에러', e);
    } on FileSystemException catch (e) {
      throw LocalDatabaseException('로컬 파일 시스템 입출력 에러', e);
    } on DatabaseException catch (e) {
      throw LocalDatabaseException('데이터베이스 초기화 에러', e);
    } catch (e) {
      throw LocalDatabaseException('알 수 없는 에러', e);
    }
  }

  /// 데이터베이스에서 북마크를 불러와 반환한다.
  @override
  Future<BookmarkModel> getBookmarks() async {
    try {
      final Database db = await _getDatabase();
      final List<Map<String, dynamic>> result = await db.query(tableName);
      return BookmarkModel.fromList(result);
    } catch (e) {
      throw LocalDatabaseException('북마크 불러오기 실패', e);
    }
  }

  /// 주어진 공지사항[id]을 북마크에 추가한다.
  @override
  Future<void> addBookmark(NoticeTileModel notice) async {
    try {
      final Database db = await _getDatabase();

      // 데이터베이스에 저장할 필드만 추출
      final Map<String, String> bookmarkData = {
        colId: notice.id,
        colTitle: notice.title,
        colLink: notice.link,
        colDate: notice.date,
      };

      await db.insert(
        tableName,
        bookmarkData,
        conflictAlgorithm: ConflictAlgorithm.ignore, // 중복 방지
      );

      // 캐싱 업데이트
      _bookmarkIds.add(notice.id);
    } catch (e) {
      throw LocalDatabaseException('북마크 추가 에러', e);
    }
  }

  /// 주어진 공지사항[noticeId]의 북마크를 제거한다.
  @override
  Future<void> removeBookmark(String noticeId) async {
    try {
      final Database db = await _getDatabase();

      await db.delete(
        tableName,
        where: '$colId = ?',
        whereArgs: [noticeId],
      );
      _bookmarkIds.remove(noticeId);
    } catch (e) {
      throw LocalDatabaseException('북마크 삭제 에러', e);
    }
  }

  /// 캐싱된 모든 북마크를 삭제한다.
  @override
  Future<void> clearBookmarks() async {
    try {
      final Database db = await _getDatabase();

      await db.delete(tableName);
      _bookmarkIds.clear();
      AppLogger.d('모든 북마크 삭제 완료');
    } catch (e) {
      throw LocalDatabaseException('북마크 테이블 삭제 에러', e);
    }
  }

  /// 주어진 [noticeId]의 북마크 여부를 반환한다.
  @override
  bool isBookmarked(String noticeId) {
    return _bookmarkIds.contains(noticeId);
  }

  /// 캐싱된 북마크 ID 집합을 반환한다.
  @override
  Set<String> getBookmarkIds() {
    return _bookmarkIds;
  }

  /// 초기화된 데이터베이스를 반환한다.
  Future<Database> _getDatabase() async {
    try {
      Database? db = _database;
      if (db != null) return db;

      // 데이터베이스 초기화
      await initialize();

      db = _database;

      if (db == null) {
        throw LocalDatabaseException('데이터베이스 초기화 에러');
      }

      return db;
    } on LocalDatabaseException {
      rethrow;
    } catch (e) {
      throw LocalDatabaseException('알 수 없는 에러', e);
    }
  }

  /// 데이터베이스[_database]에서 북마크 ID들을 불러와
  /// 북마크 ID 캐시[_bookmarkIds]의 동기화를 수행한다.
  Future<void> _refreshCache() async {
    try {
      final Database? db = _database;
      if (db == null) return;

      final List<Map<String, dynamic>> result =
          await db.query(tableName, columns: [colId]);
      _bookmarkIds = result.map((row) => row[colId] as String).toSet();
    } catch (e) {
      throw LocalDatabaseException('북마크 ID 불러오기 실패', e);
    }
  }
}
