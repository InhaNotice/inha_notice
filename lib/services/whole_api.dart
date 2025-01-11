import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class HeadlineTagSelectors {
  static const String kNoticeBoard = '.artclTable .headline';
  static const String kNoticeTitle = '._artclTdTitle .artclLinkView';
  static const String kNoticeDate = '._artclTdRdate';
  static const String kNoticeWriter = '._artclTdWriter';
  static const String kNoticeAccess = '._artclTdAccess';
}

class GeneralTagSelectors {
  static const String kNoticeBoard = '.artclTable tr:not(.headline)';
  static const String kNoticeTitle = '._artclTdTitle .artclLinkView';
  static const String kNoticeDate = '._artclTdRdate';
  static const String kNoticeWriter = '._artclTdWriter';
  static const String kNoticeAccess = '._artclTdAccess';
}

class PageTagSelectors {
  static const String kPageBoard = '._paging ._inner ul li';
  static const String kCurrentPage = 'strong';
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
      // 크롤링 진행
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
      final titleTag = headline.querySelector(HeadlineTagSelectors.kNoticeTitle);
      final dateTag = headline.querySelector(HeadlineTagSelectors.kNoticeDate);
      final writerTag = headline.querySelector(HeadlineTagSelectors.kNoticeWriter);
      final accessTag = headline.querySelector(HeadlineTagSelectors.kNoticeAccess);

      if (titleTag == null || dateTag == null || writerTag == null || accessTag == null) continue;

      final title = titleTag.nodes
          .where((node) => node.nodeType == 3)
          .map((node) => node.text?.trim())
          .join() ??
          '';

      final postUrl = titleTag.attributes['href'] ?? '';
      final link = baseUrl + postUrl;

      final date = dateTag.text?.trim();
      final writer = writerTag.text?.trim();
      final access = accessTag.text?.trim();

      final List<String> postUrlList = postUrl.split('/');
      final String id = (postUrlList.length > 4) ? postUrlList[4] :'unknownId';

      results.add({'id': id, 'title': title, 'link': link, 'date': date, 'writer': writer, 'access': access});
    }
    return results;
  }

  // 일반 공지사항 가져오는 함수
  List<Map<String, String>> _fetchGeneralNotices(document) {
    final generals = document.querySelectorAll(GeneralTagSelectors.kNoticeBoard);
    final List<Map<String, String>> results = [];
    for (var general in generals.skip(1)) {
      final titleTag = general.querySelector(GeneralTagSelectors.kNoticeTitle);
      final dateTag = general.querySelector(GeneralTagSelectors.kNoticeDate);
      final writerTag = general.querySelector(GeneralTagSelectors.kNoticeWriter);
      final accessTag = general.querySelector(GeneralTagSelectors.kNoticeAccess);

      if (titleTag == null || dateTag == null || writerTag == null || accessTag == null) continue;

      final title = titleTag.nodes
          .where((node) => node.nodeType == 3)
          .map((node) => node.text?.trim())
          .join() ??
          '';

      final postUrl = titleTag.attributes['href'] ?? '';
      final link = baseUrl + postUrl;

      final date = dateTag.text?.trim();
      final writer = writerTag.text?.trim();
      final access = accessTag.text?.trim();

      final List<String> postUrlList = postUrl.split('/');
      final String id = (postUrlList.length > 4) ? postUrlList[4] :'unknownId';

      results.add({'id': id,'title': title, 'link': link, 'date': date, 'writer': writer, 'access': access});
    }
    return results;
  }

  // 페이지 번호 가져오는 함수
  List<Map<String, dynamic>> _fetchPages(document) {
    final pages = document.querySelectorAll(PageTagSelectors.kPageBoard);
    final List<Map<String, dynamic>> results = [];
    for (var page in pages) {
      final bool isCurrent = (page.localName == PageTagSelectors.kCurrentPage);

      results.add({
        'page': int.parse(page.text.trim()),
        'isCurrent': isCurrent,
      });
    }
    return results;
  }
}