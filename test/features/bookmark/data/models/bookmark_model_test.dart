import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/features/bookmark/data/models/bookmark_model.dart';

void main() {
  group('BookmarkModel 유닛 테스트', () {
    test('fromList는 Map 목록을 NoticeTileModel 목록으로 변환한다', () {
      final model = BookmarkModel.fromList([
        {
          'id': '1',
          'title': '학사 공지',
          'link': '/1',
          'date': '2026-02-19',
        },
        {
          'id': '2',
          'title': '장학 공지',
          'link': '/2',
          'date': '2026-02-18',
        },
      ]);

      expect(model.bookmarks.length, 2);
      expect(model.bookmarks.first.title, '학사 공지');
      expect(model.bookmarks.last.id, '2');
    });
  });
}
