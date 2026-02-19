import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:inha_notice/features/bookmark/data/models/bookmark_model.dart';
import 'package:inha_notice/features/bookmark/data/repositories/bookmark_repository_impl.dart';

class _FakeBookmarkLocalDataSource implements BookmarkLocalDataSource {
  BookmarkModel bookmarks = const BookmarkModel(bookmarks: []);
  Object? getError;
  Object? clearError;
  Object? removeError;
  String? removedId;
  bool cleared = false;

  @override
  Future<void> addBookmark(NoticeTileModel notice) async {}

  @override
  Future<void> clearBookmarks() async {
    if (clearError != null) throw clearError!;
    cleared = true;
  }

  @override
  Set<String> getBookmarkIds() => {};

  @override
  Future<BookmarkModel> getBookmarks() async {
    if (getError != null) throw getError!;
    return bookmarks;
  }

  @override
  Future<void> initialize() async {}

  @override
  bool isBookmarked(String noticeId) => false;

  @override
  Future<void> removeBookmark(String noticeId) async {
    if (removeError != null) throw removeError!;
    removedId = noticeId;
  }
}

void main() {
  group('BookmarkRepositoryImpl 유닛 테스트', () {
    test('getBookmarks 성공 시 Right를 반환한다', () async {
      final local = _FakeBookmarkLocalDataSource()
        ..bookmarks = const BookmarkModel(bookmarks: [
          NoticeTileModel(id: '1', title: '학사', link: '/1', date: '2026-02-19'),
        ]);
      final repository = BookmarkRepositoryImpl(localDataSource: local);

      final result = await repository.getBookmarks();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Right 이어야 합니다.'),
        (entity) => expect(entity.bookmarks.first.id, '1'),
      );
    });

    test('getBookmarks 실패 시 Failure를 반환한다', () async {
      final local = _FakeBookmarkLocalDataSource()..getError = Exception('db');
      final repository = BookmarkRepositoryImpl(localDataSource: local);

      final result = await repository.getBookmarks();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, 'Exception: db'),
        (_) => fail('Left 이어야 합니다.'),
      );
    });

    test('removeBookmark는 int id를 문자열로 변환해 전달한다', () async {
      final local = _FakeBookmarkLocalDataSource();
      final repository = BookmarkRepositoryImpl(localDataSource: local);

      final result = await repository.removeBookmark(123);

      expect(local.removedId, '123');
      expect(result, const Right(null));
    });

    test('clearBookmarks 실패 시 Failure를 반환한다', () async {
      final local = _FakeBookmarkLocalDataSource()
        ..clearError = Exception('clear');
      final repository = BookmarkRepositoryImpl(localDataSource: local);

      final result = await repository.clearBookmarks();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, 'Exception: clear'),
        (_) => fail('Left 이어야 합니다.'),
      );
    });
  });
}
