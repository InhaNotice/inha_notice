/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-24
 */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:inha_notice/core/constants/status_code_constants.dart';
import 'package:inha_notice/selectors/major_style_tag_selectors.dart';
import 'package:inha_notice/services/absolute_style_scraper/base_absolute_style_notice_scraper.dart';

/// **MajorStyleNoticeScraper**
/// 이 클래스는 인하대학교 학과 스타일의 공지사항을 크롤링하는 클래스입니다.
class MajorStyleNoticeScraper extends BaseAbsoluteStyleNoticeScraper {
  late final String baseUrl;
  late final String queryUrl;
  late final String noticeType;

  MajorStyleNoticeScraper(this.noticeType) {
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

  @override
  List<Map<String, String>> fetchHeadlineNotices(document) {
    final headlines =
        document.querySelectorAll(HeadlineTagSelectors.kNoticeBoard);

    final List<Map<String, String>> results = [];
    for (var headline in headlines) {
      final titleLinkTag =
          headline.querySelector(HeadlineTagSelectors.kNoticeTitleLink);
      final titleStrongTag =
          headline.querySelector(HeadlineTagSelectors.kNoticeTitleStrong);
      final dateTag = headline.querySelector(HeadlineTagSelectors.kNoticeDate);
      final writerTag =
          headline.querySelector(HeadlineTagSelectors.kNoticeWriter);
      final accessTag =
          headline.querySelector(HeadlineTagSelectors.kNoticeAccess);

      // 필수 태그(학과 공지 스타일의 태그는 고정적): titleLinkTag, titleStrongTag, dataTag, writerTag, accessTag
      if (titleLinkTag == null ||
          titleStrongTag == null ||
          dateTag == null ||
          writerTag == null ||
          accessTag == null) {
        continue;
      }

      final postUrl = titleLinkTag.attributes['href'] ?? '';

      final String id = makeUniqueNoticeId(postUrl);
      final String title = titleStrongTag.nodes
              .where((node) => node.nodeType == 3)
              .map((node) => node.text?.trim())
              .join() ??
          '';
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

  @override
  List<Map<String, String>> fetchGeneralNotices(document) {
    final generals =
        document.querySelectorAll(GeneralTagSelectors.kNoticeBoard);
    final List<Map<String, String>> results = [];
    for (var general in generals.skip(1)) {
      final titleLinkTag =
          general.querySelector(GeneralTagSelectors.kNoticeTitleLink);
      final titleStrongTag =
          general.querySelector(GeneralTagSelectors.kNoticeTitleStrong);
      final dateTag = general.querySelector(GeneralTagSelectors.kNoticeDate);
      final writerTag =
          general.querySelector(GeneralTagSelectors.kNoticeWriter);
      final accessTag =
          general.querySelector(GeneralTagSelectors.kNoticeAccess);

      if (titleLinkTag == null ||
          titleStrongTag == null ||
          dateTag == null ||
          writerTag == null ||
          accessTag == null) {
        continue;
      }

      final postUrl = titleLinkTag.attributes['href'] ?? '';
      final String id = makeUniqueNoticeId(postUrl);

      final String title = titleStrongTag.nodes
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

  @override
  List<Map<String, dynamic>> fetchPages(document,
      [String? searchColumn, String? searchWord]) {
    final List<Map<String, dynamic>> results = [];
    final pages = document.querySelector(PageTagSelectors.kPageBoard);
    if (pages == null) return results;
    final lastPageHref =
        pages.querySelector(PageTagSelectors.kLastPage)?.attributes['href'] ??
            '';
    if (lastPageHref == '') return results;

    final match = RegExp(r"page_link\('(\d+)'\)").firstMatch(lastPageHref);
    final lastPage = int.parse(match?.group(1) ?? '1');
    for (int i = 1; i <= lastPage; i++) {
      final int page = i;
      final bool isCurrent = (i == 1) ? true : false;
      results.add({
        'page': page,
        'isCurrent': isCurrent,
        'searchColumn': searchColumn,
        'searchWord': searchWord
      });
    }
    return results;
  }
}
