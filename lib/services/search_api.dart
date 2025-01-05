import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

class SearchAPI {
  static const String kTagNoticeBoard = 'dl.resultsty_1';
  static const String kTagNoticeTitle = 'dt > a.tit';
  static const String kAttributeHref = 'href';
  static const String kAttributeTitle = 'title';
  static const String kAttributeOnClick = 'onclick';
  static const String kTagPage = 'div.btn_num > a.num';
  static const String kTagCurrentPage = 'div.btn_num > a.click > strong';
  static const int kHttpStatusOk = 200;

  late String baseUrl;
  late String collectionType;

  SearchAPI() {
    baseUrl = dotenv.get('SEARCH_URL');
    collectionType = dotenv.get('COLLECTION');
  }

  Future<Map<String, dynamic>> fetchNotices(String query, int startCount) async {
    try {
      // Set baseUrl from query, startCount
      final String connectedUrl = '$baseUrl?query=$query&collection=$collectionType&startCount=$startCount';

      // Request to baseUrl
      final response = await http.get(Uri.parse(connectedUrl));

      // Check http status code
      if (response.statusCode == kHttpStatusOk) {
        final document = html_parser.parse(response.body);

        // Craw notices from searched results
        final noticesElements = document.querySelectorAll(kTagNoticeBoard);

        final notices = noticesElements.map((notice) {
          final titleElement = notice.querySelector(kTagNoticeTitle);
          final link = titleElement?.attributes[kAttributeHref];
          final title = titleElement?.text.trim() ?? 'No Title';
          return {'title': title, 'link': link ?? ''};
        }).toList();

        // Craw pages from searched results
        final pageElements = document.querySelectorAll(kTagPage);
        final currentPageElement = document.querySelector(kTagCurrentPage);

        final pages = <Map<String, dynamic>>[];
        pages.add({
          'page': currentPageElement?.text.trim(),
          'startCount': '0',
          'isCurrent': true,
        });
        pages.addAll(pageElements.where((pageElement) {
          final title = pageElement.attributes[kAttributeTitle];
          return title == '페이징';
        }).map((pageElement) {
          final pageNumber = pageElement.text.trim();
          final pageLink = pageElement.attributes[kAttributeOnClick] ?? '';
          final match = RegExp(r"doPaging\('(\d+)'\)").firstMatch(pageLink);
          final startCount = match?.group(1) ?? '';
          return {
            'page': pageNumber,
            'startCount': startCount,
            'isCurrent': false,
          };
        }));

        // Return notices, pages
        return {
          'notices': notices,
          'pages': pages,
        };
      } else {
        throw Exception('Failed to load board page: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notices: $e');
    }
  }
}