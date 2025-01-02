import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

class SearchAPI {
  Future<Map<String, dynamic>> fetchNoticesWithLinks(String url, String query, {int page = 1}) async {
    try {
      final boardLink = url;

      final boardResponse = await http.get(Uri.parse(boardLink));
      if (boardResponse.statusCode == 200) {
        final boardDocument = html_parser.parse(boardResponse.body);

        // 공지사항 크롤링
        final noticesElements = boardDocument.querySelectorAll('dl.resultsty_1');
        final notices = noticesElements.map((notice) {
          final titleElement = notice.querySelector('dt > a.tit');
          final link = titleElement?.attributes['href'];
          final title = titleElement?.text.trim() ?? 'No Title';
          return {'title': title, 'link': link ?? ''};
        }).toList();

        // 페이지 정보 크롤링
        final pageElements = boardDocument.querySelectorAll('div.paginate > a'); // 페이지네이션 셀렉터
        final pages = pageElements.map((pageElement) {
          final isCurrent = pageElement.classes.contains('current'); // 현재 페이지 여부
          final pageNumber = pageElement.text.trim();
          final pageLink = pageElement.attributes['href'] ?? '';
          return {
            'pageNumber': pageNumber,
            'isCurrent': isCurrent,
            'link': pageLink,
          };
        }).toList();

        return {
          'notices': notices,
          'pages': pages,
        };
      } else {
        throw Exception('Failed to load board page: ${boardResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notices: $e');
    }
  }
}