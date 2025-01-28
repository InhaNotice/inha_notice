import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:inha_notice/services/base_notice_scraper.dart';
import 'package:inha_notice/utils/major_storage.dart';
import 'package:inha_notice/selectors/major_tag_selectors.dart';
import 'package:inha_notice/constants/status_code_constants.dart';

class MajorNoticeScraper extends BaseNoticeScraper {
  late final String baseUrl;
  late final String queryUrl;

  MajorNoticeScraper();

  Future<void> initialize() async {
    await MajorStorage.init();
    String? major = await MajorStorage.getMajor();
    baseUrl = dotenv.get('${major}_URL');
    queryUrl = dotenv.get('${major}_QUERY_URL');
  }

  @override
  Future<Map<String, dynamic>> fetchNotices(int page, String noticeType) async {
    try {
      // 크롤링 진행
      final String connectUrl = '$queryUrl$page';
      final response = await http.get(Uri.parse(connectUrl));

      if (response.statusCode == StatusCodeSettings.kStatusOkay) {
        final document = parse(response.body);

        // 중요 공지사항 가져오기
        final headlineNotices = fetchHeadlineNotices(document);

        // 일반 공지사항 가져오기
        final generalNotices = fetchGeneralNotices(document);

        // 페이지 번호 가져오기
        final pages = fetchPages(document);

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

      if (titleLinkTag == null ||
          titleStrongTag == null ||
          dateTag == null ||
          writerTag == null ||
          accessTag == null) {
        continue;
      }

      final postUrl = titleLinkTag.attributes['href'] ?? '';

      final String id = makeUniqueNoticeId(postUrl);
      final title = titleStrongTag.nodes
              .where((node) => node.nodeType == 3)
              .map((node) => node.text?.trim())
              .join() ??
          '';
      final link = baseUrl + postUrl;
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
          accessTag == null) continue;

      final postUrl = titleLinkTag.attributes['href'] ?? '';
      final String id = makeUniqueNoticeId(postUrl);

      final title = titleStrongTag.nodes
              .where((node) => node.nodeType == 3)
              .map((node) => node.text?.trim())
              .join() ??
          '';
      final link = baseUrl + postUrl;
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
  List<Map<String, dynamic>> fetchPages(document) {
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
      final page = i;
      final bool isCurrent = (i == 1) ? true : false;
      results.add({'page': page, 'isCurrent': isCurrent});
    }
    return results;
  }
}
