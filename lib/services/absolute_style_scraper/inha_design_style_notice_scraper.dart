/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-25
 */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:inha_notice/core/constants//status_code_constant.dart';
import 'package:inha_notice/core/constants/identifier_constant.dart';
import 'package:inha_notice/core/constants/string_constant.dart';
import 'package:inha_notice/selectors/inha_design_style_tag_selectors.dart';
import 'package:inha_notice/services/absolute_style_scraper/base_absolute_style_notice_scraper.dart';

/// **InhaDesignStyleNoticeScraper**
/// 인하대학교 디자인융합학과 공지사항을 크롤링 후 전처리하여 반환하는 클래스입니다.
class InhaDesignStyleNoticeScraper extends BaseAbsoluteStyleNoticeScraper {
  late final String baseUrl;
  late final String queryUrl;
  late final String noticeType;

  InhaDesignStyleNoticeScraper(this.noticeType) {
    baseUrl = dotenv.get('${noticeType}_URL');
    queryUrl = dotenv.get('${noticeType}_QUERY_URL');
  }

  @override
  Future<Map<String, dynamic>> fetchNotices(int page, String noticeType,
      [String? searchColumn, String? searchWord]) async {
    try {
      // 크롤링 진행
      final String connectUrl = '$queryUrl$page';
      final response = await http.get(Uri.parse(connectUrl));

      if (response.statusCode == StatusCodeConstant.kStatusOkay) {
        final document = parse(response.body);

        // 디자인융합학과는 중요 공지가 존재하지 않음
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
    return [];
  }

  @override
  List<Map<String, String>> fetchGeneralNotices(document) {
    final wsiteContent =
        document.querySelector(InhaDesignStyleTagSelectors.kNoticeBoard);
    if (wsiteContent == null) return [];

    final generals = wsiteContent
        .querySelectorAll(InhaDesignStyleTagSelectors.kNoticeBoardPosts);
    if (generals.isEmpty) return [];

    final List<Map<String, String>> results = [];
    for (final general in generals) {
      final titleTag =
          general.querySelector(InhaDesignStyleTagSelectors.kNoticeTitle);
      final linkTag =
          general.querySelector(InhaDesignStyleTagSelectors.kNoticeTitleLink);
      final dateTag =
          general.querySelector(InhaDesignStyleTagSelectors.kNoticeDate);

      if (titleTag == null || linkTag == null || dateTag == null) {
        continue;
      }

      // .blog-post 태그의 id 속성값
      final String id =
          general.attributes['id'] ?? IdentifierConstant.kUnknownId;

      final String title = titleTag.text.trim() ?? '';

      final String originalLink = linkTag.attributes['href'] ?? '';
      final String link = _parseLink(originalLink);

      final String originalDate = dateTag.text.trim() ?? '';
      final String date = _parseDate(originalDate);

      results.add({
        'id': id,
        'title': title,
        'link': link,
        'date': date,
      });
    }

    return results;
  }

  @override
  List<Map<String, dynamic>> fetchPages(document,
      [String? searchColumn, String? searchWord]) {
    final List<Map<String, dynamic>> results = [];

    final int lastPage = 16;
    for (int i = 1; i <= lastPage; i++) {
      final int page = i;
      final bool isCurrent = (i == 1) ? true : false;
      results.add({'page': page, 'isCurrent': isCurrent});
    }
    return results;
  }

  /// 공통 날짜 파싱 메서드 (M/D/YYYY → YYYY.MM.DD)
  String _parseDate(String originalDate) {
    final parts = originalDate.split('/');
    if (parts.length != 3) return StringConstant.kEmptyString;

    final month = parts[0].padLeft(2, '0');
    final day = parts[1].padLeft(2, '0');
    final year = parts[2];
    return '$year.$month.$day';
  }

  /// '//'로 시작하면 'http://' 붙여서 반환
  String _parseLink(String originalLink) {
    if (originalLink.startsWith('//')) {
      // // -> http:// 로 치환
      final linkWithoutSlashes = originalLink.replaceFirst('//', '');
      return 'http://$linkWithoutSlashes';
    }
    return originalLink;
  }
}
