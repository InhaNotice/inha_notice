/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:http_status_code/http_status_code.dart';
import 'package:inha_notice/core/constants/identifier_constants.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/features/search/domain/entities/search_selectors.dart';

/// **SearchSraper**
/// 이 클래스는 사용자의 입력에 따른 검색 크롤링을 정의하는 클래스입니다.
class SearchScraper {
  late String baseUrl;
  late String collectionType;

  SearchScraper() {
    baseUrl = dotenv.get('SEARCH_URL');
    collectionType = dotenv.get('COLLECTION');
  }

  /// **사용자 입력에 따른 공지사항을 크롤링**
  /// 파라미터: query(사용자 입력), startCount(페이지), sortedType(정렬 옵션)
  Future<Map<String, dynamic>> fetchNotices(
      String query, int startCount, String sortedType) async {
    try {
      // 크롤링 진행
      final String connectUrl =
          '$baseUrl?query=$query&collection=$collectionType&startCount=$startCount&sort=$sortedType';
      final response = await http.get(Uri.parse(connectUrl));

      if (response.statusCode == StatusCode.OK) {
        final document = html_parser.parse(response.body);

        // 검색된 공지사항 가져오기
        final searchedNotices = fetchSearchedNotices(document);

        // 페이지 번호 가져오기
        final pages = fetchPages(document);

        return {
          'headline': [],
          'general': searchedNotices,
          'pages': pages,
        };
      } else {
        throw Exception('Failed to load board page: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notices: $e');
    }
  }

  /// **응답 객체를 통해 검색 결과를 전처리**
  List<Map<String, dynamic>> fetchSearchedNotices(dynamic document) {
    // dl.resultsty_1 태그를 가져오기(여러 개일 수 있음)
    final notices = document.querySelectorAll(SearchSelectors.result.item);
    final List<Map<String, String>> results = [];

    // dl.resultsty_1 태그를 순회하면서 공지사항을 가져오기
    for (var notice in notices) {
      final titleTags = notice.querySelectorAll(SearchSelectors.result.title);
      final bodyTags = notice.querySelectorAll(SearchSelectors.result.body);
      final dateTags = notice.querySelectorAll(SearchSelectors.result.date);

      for (int i = 0; i < titleTags.length; i++) {
        final titleTag = (i < titleTags.length) ? titleTags[i] : null;
        final bodyTag = (i < bodyTags.length) ? bodyTags[i] : null;
        final dateTag = (i < dateTags.length) ? dateTags[i] : null;

        // 필수 태그: titleTag(title, link), dateTag
        if (titleTag == null || dateTag == null) {
          continue;
        }

        final postUrl =
            titleTag.attributes[SearchSelectors.result.hrefAttr] ?? '';

        final id = makeUniqueNoticeId(postUrl);
        final title = titleTag.text.trim();

        /// body는 필수가 아님. bodyTag가 null이면 빈 문자열을 저장
        /// 빈 문자열은 이후 NoticeListTile 출력시 빈 문자열인지 확인하여 body를 출력할지 결정하게 됨
        final body = (bodyTag != null) ? bodyTag.text.trim() : '';
        final link = postUrl;
        final date = dateTag.text.trim();

        results.add({
          'id': id,
          'title': title,
          'body': body,
          'link': link,
          'date': date
        });
      }
    }
    return results;
  }

  /// **응답 객체를 통해 마지막 페이지 분석 후 페이지네이션 리턴**
  Pages fetchPages(dynamic document,
      [String? searchColumn, String? searchWord]) {
    final Pages results = createPages(searchColumn, searchWord);

    final pages = document.querySelectorAll(SearchSelectors.pagination.number);
    if (pages.isEmpty) return results;

    final String? lastPageOnClick = pages.last.attributes['onclick'];
    if (lastPageOnClick == null) return results;

    final match = RegExp(r"doPaging\('(\d+)'\)").firstMatch(lastPageOnClick);
    int lastPage = int.parse(match?.group(1) ?? '1');
    if (lastPage != 1) {
      lastPage = lastPage ~/ 10 + 1;
      // 최대 50페이지로 제한
      lastPage = (lastPage > 50) ? 50 : lastPage;
    }
    // lastPage 기준으로 페이지 버튼 생성
    for (int i = 1; i <= lastPage; i++) {
      final int page = i;
      // SearchPage는 Relative style이라 상댓값 사용
      final int startCount = (i - 1) * 10;
      results['pageMetas'].add({'page': page, 'startCount': startCount});
    }
    return results;
  }

  /// **공지사항 게시물의 고유 id를 생성**
  String makeUniqueNoticeId(String postUrl) {
    // postUrl이 빈 문자열인지 확인합니다.
    if (postUrl.isEmpty) {
      return IdentifierConstants.kUnknownId;
    }

    final List<String> postUrlList = postUrl.split('/');
    // postUrlList가 정해진 규격을 따르는지 확인합니다.
    if (postUrlList.length <= 6) {
      return IdentifierConstants.kUnknownId;
    }

    final String provider = postUrlList[4];
    final String postId = postUrlList[6];
    final String uniqueNoticeId = '$provider-$postId';
    return uniqueNoticeId;
  }
}
