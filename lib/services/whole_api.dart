import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class HeadlineTagSelectors {
  static const String kNoticeBoard = '.artclTable .headline ._artclTdTitle';
  static const String kNoticeLink = '.artclLinkView';
}

class GeneralTagSelectors {
  static const String kNoticeBoard = '.artclTable tr:not(.headline)';
  static const String kNoticeLink = '._artclTdTitle a';
}

class PageTagSelectors {
  static const String kPageBoard = '._paging ._inner ul li';
}

class WholeAPI {
  late final String baseUrl;
  late final String queryUrl;

  WholeAPI() {
    baseUrl = dotenv.get('WHOLE_URL');
    queryUrl = dotenv.get('WHOLE_QUERY_URL');
  }

  Future<Map<String, dynamic>> fetchNotices(int page) async {
    try {
      final String connectUrl = '$queryUrl$page';
      final response = await http.get(Uri.parse(connectUrl));

      if (response.statusCode == 200) {
        final document = parse(response.body);

        // 중요 공지사항 가져오기
        final headlineNotices = _fetchHeadlineNotices(document);

        // 일반 공지사항 가져오기
        final generalNotices = _fetchGeneralNotices(document);

        // 페이지 번호 가져오기
        final pages = _fetchPages(document);

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
  List<Map<String, String>> _fetchHeadlineNotices(document) {
    final headlines = document.querySelectorAll(HeadlineTagSelectors.kNoticeBoard);

    final List<Map<String, String>> results = [];
    for (var headline in headlines) {
      final aTag = headline.querySelector(HeadlineTagSelectors.kNoticeLink);
      if (aTag == null) continue;

      final title = aTag.nodes
          .where((node) => node.nodeType == 3)
          .map((node) => node.text?.trim())
          .join() ??
          '';
      final link = baseUrl + (aTag.attributes['href'] ?? '');

      results.add({'title': title, 'link': link});
    }
    return results;
  }

  // 일반 공지사항 가져오는 함수
  List<Map<String, String>> _fetchGeneralNotices(document) {
    final generals = document.querySelectorAll(GeneralTagSelectors.kNoticeBoard);
    final List<Map<String, String>> results = [];
    for (var general in generals.skip(1)) {
      final aTag = general.querySelector(GeneralTagSelectors.kNoticeLink);
      if (aTag == null) continue;

      final title = aTag.nodes
          .where((node) => node.nodeType == 3)
          .map((node) => node.text?.trim())
          .join() ??
          '';
      final link = baseUrl + (aTag.attributes['href'] ?? '');

      results.add({'title': title, 'link': link});
    }
    return results;
  }

  // 페이지 번호 가져오는 함수
  List<Map<String, dynamic>> _fetchPages(document) {
    final pages = document.querySelectorAll(PageTagSelectors.kPageBoard);
    final List<Map<String, dynamic>> results = [];
    for (var page in pages) {
      final bool isCurrent = page.localName == 'strong';

      results.add({
        'page': int.parse(page.text.trim()),
        'isCurrent': isCurrent,
      });
    }
    return results;
  }
}