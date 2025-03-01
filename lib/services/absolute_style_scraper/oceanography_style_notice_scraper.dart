/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-03-01
 */

import 'package:charset_converter/charset_converter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:inha_notice/constants/identifier_constants.dart';
import 'package:inha_notice/constants/status_code_constants.dart';
import 'package:inha_notice/constants/string_constants.dart';
import 'package:inha_notice/selectors/oceanography_style_tag_selectors.dart';
import 'package:inha_notice/services/absolute_style_scraper/base_absolute_style_notice_scraper.dart';

/// **OceanographyStyleNoticeScraper**
/// 인하대학교 해양과학과의 공지사항을 크롤링하여 반환합니다.
class OceanographyStyleNoticeScraper extends BaseAbsoluteStyleNoticeScraper {
  late final String baseUrl;
  late final String queryUrl;
  late final String noticeType;

  OceanographyStyleNoticeScraper(this.noticeType) {
    baseUrl = dotenv.get('${noticeType}_URL');
    queryUrl = dotenv.get('${noticeType}_QUERY_URL');
  }

  @override
  Future<Map<String, dynamic>> fetchNotices(int page, String noticeType) async {
    try {
      // 크롤링 진행
      final String requestUrl = '$queryUrl$page';
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == StatusCodeSettings.kStatusOkay) {
        // 응답 바이트를 euc-kr로 디코딩
        final decodedHtml = await CharsetConverter.decode(
            StringConstants.kEUCKR, response.bodyBytes);
        final document = parse(decodedHtml);

        // 중요 공지사항 가져오기
        final headlineNotices = fetchHeadlineNotices(document);

        // 일반 공지사항 가져오기
        final generalNotices = fetchGeneralNotices(document);

        // 페이지 번호 가져오기
        final List<Map<String, dynamic>> pages = fetchPages(document);

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
  List<Map<String, String>> fetchHeadlineNotices(Document document) {
    // 테이블 선택
    final tableElements =
        document.querySelectorAll(OceanographyStyleTagSelectors.kNoticeBoard);
    if (tableElements.isEmpty) return [];

    // 두 번째 <table> (인덱스 1)에 실제 공지사항 목록이 있다고 가정
    final noticeTableList = tableElements[0]
        .querySelectorAll(OceanographyStyleTagSelectors.kNoticeBoardTable);
    if (noticeTableList.length < 2) return [];

    final noticeTable = noticeTableList[1];
    final rowElements = noticeTable.querySelectorAll('tr');

    // <td>가 정확히 6개인 <tr>만 필터링
    final headlines = rowElements.where((tr) {
      return tr.querySelectorAll('td').length == 6;
    }).toList();

    final List<Map<String, String>> results = [];
    for (final headline in headlines) {
      final tdList = headline.querySelectorAll('td');
      // td 태그의 개수가 6개이면, 공지가 존재하는걸로 판단
      if (tdList.length < 6) continue;

      final noticeIndexTag = tdList[1];
      final titleTag = tdList[2];
      final dateTag = tdList[4];
      final writerTag = tdList[3];
      final accessTag = tdList[5];

      final String noticeIndex = noticeIndexTag.text.trim();
      // [공지] 표시가 있는 행만 중요 공지로 간주
      if (noticeIndex != OceanographyStyleTagSelectors.kHeadline) {
        continue;
      }

      final linkTag = headline.querySelector('a');
      final postUrl = linkTag?.attributes['href'] ?? '';

      final String id = makeUniqueNoticeId(postUrl);
      final String link = baseUrl + postUrl;
      final String title = titleTag.text.trim();
      final String date = dateTag.text.trim();
      final String writer = writerTag.text.trim();
      final String access = accessTag.text.trim();

      results.add({
        'id': id,
        'title': title,
        'link': link,
        'date': date,
        'writer': writer,
        'access': access,
      });
    }
    return results;
  }

  @override
  List<Map<String, String>> fetchGeneralNotices(Document document) {
    // 테이블 선택
    final tableElements =
        document.querySelectorAll(OceanographyStyleTagSelectors.kNoticeBoard);
    if (tableElements.isEmpty) return [];

    final noticeTableList = tableElements[0]
        .querySelectorAll(OceanographyStyleTagSelectors.kNoticeBoardTable);
    if (noticeTableList.length < 2) return [];

    final noticeTable = noticeTableList[1];
    final rowElements = noticeTable.querySelectorAll('tr');

    // <td>가 정확히 6개인 <tr>만 필터링
    final generals = rowElements.where((tr) {
      return tr.querySelectorAll('td').length == 6;
    }).toList();

    final List<Map<String, String>> results = [];
    // generals의 첫 번째는 목차이므로 스킵
    for (final general in generals.skip(1)) {
      final tdList = general.querySelectorAll('td');
      if (tdList.length < 6) continue;

      final noticeIndexTag = tdList[1];
      final titleTag = tdList[2];
      final dateTag = tdList[4];
      final writerTag = tdList[3];
      final accessTag = tdList[5];

      final noticeTag = noticeIndexTag.text.trim();
      // [공지]가 아닌 일반 공지 추출
      if (noticeTag == OceanographyStyleTagSelectors.kHeadline) {
        continue;
      }

      final linkTag = general.querySelector('a');
      final postUrl = linkTag?.attributes['href'] ?? '';

      final String id = makeUniqueNoticeId(postUrl);
      final String link = baseUrl + postUrl;
      final String title = titleTag.text.trim();
      final String writer = writerTag.text.trim();
      final String date = dateTag.text.trim();
      final String access = accessTag.text.trim();

      results.add({
        'id': id,
        'title': title,
        'link': link,
        'date': date,
        'writer': writer,
        'access': access,
      });
    }
    return results;
  }

  @override
  List<Map<String, dynamic>> fetchPages(Document document) {
    final List<Map<String, dynamic>> results = [];

    final tableElements =
        document.querySelectorAll(OceanographyStyleTagSelectors.kNoticeBoard);
    if (tableElements.isEmpty) return results;

    final tableList = tableElements[0]
        .querySelectorAll(OceanographyStyleTagSelectors.kNoticeBoardTable);
    // 세 번째 테이블(인덱스 2)에 페이지 정보 존재함
    if (tableList.length < 3) return results;

    final pageTable = tableList[2];
    // 정확한 구조에 맞게 CSS 선택자 수정
    final anchor =
        pageTable.querySelector(OceanographyStyleTagSelectors.kPageBoard);

    final href = anchor?.attributes['href'] ?? '';
    final uri = Uri.parse(href);
    final lastPageNum = int.parse(uri.queryParameters['page'] ?? '1');

    for (int i = 1; i <= lastPageNum; i++) {
      final int page = i;
      final bool isCurrent = (i == 1) ? true : false;
      results.add({
        'page': page,
        'isCurrent': isCurrent,
      });
    }
    return results;
  }

  @override
  String makeUniqueNoticeId(String postUrl) {
    // postUrl이 빈 문자열인지 확인
    if (postUrl.isEmpty) {
      return IdentifierConstants.kUnknownId;
    }

    final List<String> segments = postUrl.split('/');
    // postUrlList가 정해진 규격을 따르는지 확인
    if (segments.length < 3) {
      return IdentifierConstants.kUnknownId;
    }

    final uri = Uri.parse(segments[2]);

    final String provider = OceanographyStyleTagSelectors.kProvider;
    final String? postId = uri.queryParameters['idx'];

    // postId가 존재하는지 확인
    if (postId == null) {
      return IdentifierConstants.kUnknownId;
    }

    final String uniqueNoticeId = '$provider-$postId';

    return uniqueNoticeId;
  }
}
