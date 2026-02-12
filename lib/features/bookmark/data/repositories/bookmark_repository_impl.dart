/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:inha_notice/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:inha_notice/features/bookmark/domain/failures/bookmark_failure.dart';
import 'package:inha_notice/features/bookmark/domain/repositories/bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkLocalDataSource localDataSource;

  BookmarkRepositoryImpl({required this.localDataSource});

  /// 로컬 저장소의 북마크를 불러온다.
  ///
  /// 성공 시 [BookmarkEntity]를 반환하며,
  /// 실패 시 [BookmarkFailure]를 반환한다.
  @override
  Future<Either<BookmarkFailure, BookmarkEntity>> getBookmarks() async {
    try {
      final BookmarkEntity result = await localDataSource.getBookmarks();
      return Right(result);
    } catch (e) {
      return Left(BookmarkFailure.bookmarks(e.toString()));
    }
  }

  @override
  Future<Either<BookmarkFailure, void>> clearBookmarks() async {
    try {
      await localDataSource.clearBookmarks();
      return Right(null);
    } catch (e) {
      return Left(BookmarkFailure.bookmarks(e.toString()));
    }
  }

  @override
  Future<Either<BookmarkFailure, void>> removeBookmark(int id) async {
    try {
      await localDataSource.removeBookmark(id.toString());
      return Right(null);
    } catch (e) {
      return Left(BookmarkFailure.bookmarks(e.toString()));
    }
  }
}
