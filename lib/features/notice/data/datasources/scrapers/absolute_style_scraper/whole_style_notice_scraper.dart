/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:inha_notice/core/constants/status_code_constants.dart';
import 'package:inha_notice/features/notice/data/datasources/scrapers/absolute_style_scraper/base_absolute_style_notice_scraper.dart';
import 'package:inha_notice/models/pages_model.dart';
import 'package:inha_notice/utils/selectors/whole_tag_selectors.dart';

/// **WholeNoticeScraper**
/// 이 클래스는 인하대학교 학사 공지사항을 크롤링하는 클래스입니다.
class WholeStyleNoticeScraper extends BaseAbsoluteStyleNoticeScraper {
  late final String baseUrl;
  late final String queryUrl;
  late final String noticeType;

  WholeStyleNoticeScraper(this.noticeType) {
    baseUrl = dotenv.get('${noticeType}_URL');
    queryUrl = dotenv.get('${noticeType}_QUERY_URL');
  }

  @override
  Future<Map<String, dynamic>> fetchNotices(int page, String noticeType,
      [String? searchColumn, String? searchWord]) async {
    try {
      // keyword 검색 여부에 따른 connectUrl 정의
      final String connectUrl =
          (searchColumn != null && searchWord != null && searchWord.isNotEmpty)
              ? '$queryUrl$page&srchColumn=$searchColumn&srchWrd=$searchWord'
              : '$queryUrl$page';
      final response = await http.get(Uri.parse(connectUrl));

      if (response.statusCode == StatusCodeConstants.kStatusOkay) {
        final document = parse(response.body);

        // 중요 공지사항 가져오기
        final headlineNotices = fetchHeadlineNotices(document);

        // 일반 공지사항 가져오기
        final generalNotices = fetchGeneralNotices(document);

        // 페이지 번호 가져오기
        final pages = fetchPages(document, searchColumn, searchWord);

        return {
          'headline': headlineNotices,
          'general': generalNotices,
          'pages': pages,
        };
      } else {
        throw Exception('Failed to load notices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notices: $e');
    }
  }

  // 중요 공지사항 가져오는 함수
  @override
  List<Map<String, String>> fetchHeadlineNotices(document) {
    final headlines =
        document.querySelectorAll(HeadlineTagSelectors.kNoticeBoard);

    final List<Map<String, String>> results = [];
    for (var headline in headlines) {
      final titleTag =
          headline.querySelector(HeadlineTagSelectors.kNoticeTitle);
      final dateTag = headline.querySelector(HeadlineTagSelectors.kNoticeDate);
      final writerTag =
          headline.querySelector(HeadlineTagSelectors.kNoticeWriter);
      final accessTag =
          headline.querySelector(HeadlineTagSelectors.kNoticeAccess);

      if (titleTag == null ||
          dateTag == null ||
          writerTag == null ||
          accessTag == null) {
        continue;
      }

      final postUrl = titleTag.attributes['href'] ?? '';

      final String id = makeUniqueNoticeId(postUrl);
      final String title = titleTag.nodes
          .where((node) => node.nodeType == 3)
          .map((node) => node.text?.trim())
          .join();
      final String link = baseUrl + postUrl;
      final String date = dateTag.text.trim();
      final String writer = writerTag.text.trim();
      final String access = accessTag.text.trim();

      results.add({
        'id': id,
        'title': title,
        'link': link,
        'date': date,
        'writer': writer,
        'access': access
      });
    }
    return results;
  }

  // 일반 공지사항 가져오는 함수
  @override
  List<Map<String, String>> fetchGeneralNotices(document) {
    final generals =
        document.querySelectorAll(GeneralTagSelectors.kNoticeBoard);
    final List<Map<String, String>> results = [];
    for (var general in generals.skip(1)) {
      final titleTag = general.querySelector(GeneralTagSelectors.kNoticeTitle);
      final dateTag = general.querySelector(GeneralTagSelectors.kNoticeDate);
      final writerTag =
          general.querySelector(GeneralTagSelectors.kNoticeWriter);
      final accessTag =
          general.querySelector(GeneralTagSelectors.kNoticeAccess);

      // 필수 태그(학사 공지 태그는 고정적): titleTag, dateTag, writerTag, accessTag
      if (titleTag == null ||
          dateTag == null ||
          writerTag == null ||
          accessTag == null) {
        continue;
      }

      final String postUrl = titleTag.attributes['href'] ?? '';

      final String id = makeUniqueNoticeId(postUrl);
      final String title = titleTag.nodes
          .where((node) => node.nodeType == 3)
          .map((node) => node.text?.trim())
          .join();
      final String link = baseUrl + postUrl;
      // date의 문자열 마지막이 마침표로 끝난다면 제거하여 값을 저장함('YYYY.MM.DD')
      final String date = dateTag.text.trim().replaceAll(RegExp(r'\.$'), '');
      final String writer = writerTag.text.trim();
      final String access = accessTag.text.trim();

      results.add({
        'id': id,
        'title': title,
        'link': link,
        'date': date,
        'writer': writer,
        'access': access
      });
    }
    return results;
  }

  // 페이지 번호 가져오는 함수
  @override
  Pages fetchPages(document, [String? searchColumn, String? searchWord]) {
    final Pages results = createPages(searchColumn, searchWord);

    final pages = document.querySelector(PageTagSelectors.kPageBoard);
    if (pages == null) return results;

    final lastPageHref =
        pages.querySelector(PageTagSelectors.kLastPage)?.attributes['href'] ??
            '';
    if (lastPageHref == '') return results;

    final match = RegExp(r"page_link\('(\d+)'\)").firstMatch(lastPageHref);
    final lastPage = int.parse(match?.group(1) ?? '1');
    for (int i = 1; i <= lastPage; i++) {
      final page = i;
      results['pageMetas'].add({'page': page});
    }
    return results;
  }
}
