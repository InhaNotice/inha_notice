import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:inha_notice/features/bookmark/domain/failures/bookmark_failure.dart';
import 'package:inha_notice/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/clear_bookmarks_use_case.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/get_bookmarks_use_case.dart';
import 'package:inha_notice/features/bookmark/domain/usecases/remove_bookmark_use_case.dart';

class _FakeBookmarkRepository implements BookmarkRepository {
  Either<BookmarkFailure, BookmarkEntity> getBookmarksResult =
      Right(const BookmarkEntity(bookmarks: []));
  Either<BookmarkFailure, void> clearResult = const Right(null);
  Either<BookmarkFailure, void> removeResult = const Right(null);
  int? lastRemovedId;

  @override
  Future<Either<BookmarkFailure, void>> clearBookmarks() async {
    return clearResult;
  }

  @override
  Future<Either<BookmarkFailure, BookmarkEntity>> getBookmarks() async {
    return getBookmarksResult;
  }

  @override
  Future<Either<BookmarkFailure, void>> removeBookmark(int id) async {
    lastRemovedId = id;
    return removeResult;
  }
}

void main() {
  group('Bookmark UseCase 유닛 테스트', () {
    test('GetBookmarksUseCase는 저장소 결과를 그대로 반환한다', () async {
      final repository = _FakeBookmarkRepository()
        ..getBookmarksResult = Right(const BookmarkEntity(bookmarks: [
          NoticeTileModel(id: '1', title: '학사', link: '/1', date: '2026-02-19'),
        ]));
      final useCase = GetBookmarksUseCase(repository: repository);

      final result = await useCase();

      expect(result.isRight(), isTrue);
    });

    test('RemoveBookmarkUseCase는 id를 전달한다', () async {
      final repository = _FakeBookmarkRepository();
      final useCase = RemoveBookmarkUseCase(repository: repository);

      final result = await useCase(10);

      expect(repository.lastRemovedId, 10);
      expect(result, const Right(null));
    });

    test('ClearBookmarksUseCase는 저장소 결과를 그대로 반환한다', () async {
      final repository = _FakeBookmarkRepository();
      final useCase = ClearBookmarksUseCase(repository: repository);

      final result = await useCase();

      expect(result, const Right(null));
    });
  });
}
