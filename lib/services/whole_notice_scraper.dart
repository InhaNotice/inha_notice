import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:inha_notice/selectors/tag_selectors.dart';

class WholeNoticeScraper {
  late final String baseUrl;
  late final String queryUrl;

  WholeNoticeScraper() {
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
    final List<Map<String, dynamic>> results = [];
    final pages = document.querySelector(PageTagSelectors.kPageBoard);
    if (pages == null) return results;

    final lastPageHref = pages.querySelector(PageTagSelectors.kLastPage).attributes['href'] ?? '';
    if (lastPageHref == '') return results;

    final match = RegExp(r"page_link\('(\d+)'\)").firstMatch(lastPageHref);
    final lastPage = int.parse(match?.group(1) ?? '1');
    for (int i = 1; i <= lastPage; i++) {
      final page = i;
      final bool isCurrent = (i == 1) ? true : false;
      results.add({'page': page, 'isCurrent': isCurrent});
    }
    return results;
  }
}