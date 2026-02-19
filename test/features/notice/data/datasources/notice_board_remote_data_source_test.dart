/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-19
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/features/notice/data/datasources/notice_board_remote_data_source.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/absolute_style_scraper/base_absolute_style_notice_scraper.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/relative_style_scraper/base_relative_style_notice_scraper.dart';

class _FakeAbsoluteScraper extends BaseAbsoluteStyleNoticeScraper {
  Map<String, dynamic> result = {
    'headline': [],
    'general': [],
    'pages': createPages(),
  };

  int? lastPage;
  String? lastNoticeType;
  String? lastSearchColumn;
  String? lastSearchWord;

  @override
  Future<Map<String, dynamic>> fetchNotices(int page, String noticeType,
      [String? searchColumn, String? searchWord]) async {
    lastPage = page;
    lastNoticeType = noticeType;
    lastSearchColumn = searchColumn;
    lastSearchWord = searchWord;
    return result;
  }

  @override
  List<Map<String, String>> fetchGeneralNotices(document) => [];

  @override
  List<Map<String, String>> fetchHeadlineNotices(document) => [];

  @override
  Pages fetchPages(document, [String? searchColumn, String? searchWord]) =>
      createPages(searchColumn, searchWord);
}

class _FakeRelativeScraper extends BaseRelativeStyleNoticeScraper {
  Map<String, dynamic> result = {
    'headline': [],
    'general': [],
    'pages': createPages(),
  };
  int? lastOffset;

  @override
  Future<Map<String, dynamic>> fetchNotices(int offset) async {
    lastOffset = offset;
    return result;
  }

  @override
  Future<List<Map<String, String>>> fetchNoticesWithParams(
      Map<String, String> params) async {
    return [];
  }

  @override
  Pages fetchPages() => createPages();

  @override
  String makeUniqueNoticeId(String postId) => postId;
}

void main() {
  group('NoticeBoardRemoteDataSourceImpl 유닛 테스트', () {
    test('fetchAbsoluteNotices는 주입된 absolute scraper를 사용해 모델로 변환한다', () async {
      final absolute = _FakeAbsoluteScraper()
        ..result = {
          'headline': [
            {
              'id': 'h1',
              'title': '헤드라인',
              'link': '/h1',
              'date': '2026-02-19',
            }
          ],
          'general': [
            {
              'id': 'g1',
              'title': '일반',
              'link': '/g1',
              'date': '2026-02-20',
            }
          ],
          'pages': {
            'pageMetas': [
              {'page': 1}
            ],
            'searchOptions': {'searchColumn': null, 'searchWord': null},
          },
        };

      final dataSource = NoticeBoardRemoteDataSourceImpl(
        absoluteScraperFactory: (_) => absolute,
        relativeScraperFactory: (_) => _FakeRelativeScraper(),
      );

      final model = await dataSource.fetchAbsoluteNotices(
        noticeType: 'WHOLE',
        page: 3,
        searchColumn: 'title',
        searchWord: '장학',
      );

      expect(absolute.lastPage, 3);
      expect(absolute.lastNoticeType, 'WHOLE');
      expect(absolute.lastSearchColumn, 'title');
      expect(absolute.lastSearchWord, '장학');
      expect(model.headlineNotices.first.id, 'h1');
      expect(model.generalNotices.first.id, 'g1');
      expect(model.pages['pageMetas'], isNotEmpty);
    });

    test('fetchRelativeNotices는 주입된 relative scraper를 사용해 모델로 변환한다', () async {
      final relative = _FakeRelativeScraper()
        ..result = {
          'headline': [],
          'general': [
            {
              'id': 'g9',
              'title': '정석',
              'link': '/g9',
              'date': '2026-02-21',
            }
          ],
          'pages': {
            'pageMetas': [
              {'page': 1, 'offset': 0}
            ],
            'searchOptions': {'searchColumn': null, 'searchWord': null},
          },
        };

      final dataSource = NoticeBoardRemoteDataSourceImpl(
        absoluteScraperFactory: (_) => _FakeAbsoluteScraper(),
        relativeScraperFactory: (_) => relative,
      );

      final model = await dataSource.fetchRelativeNotices(
          noticeType: 'LIBRARY', offset: 10);

      expect(relative.lastOffset, 10);
      expect(model.generalNotices.first.id, 'g9');
    });

    test('기본 relative factory는 미지원 타입에서 예외를 던진다', () async {
      final dataSource = NoticeBoardRemoteDataSourceImpl();

      expect(
        () => dataSource.fetchRelativeNotices(noticeType: 'WHOLE', offset: 0),
        throwsA(isA<Exception>()),
      );
    });
  });
}
