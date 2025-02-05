import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:inha_notice/constants/identifier_constants.dart';
import 'package:inha_notice/constants/status_code_constants.dart';
import 'package:inha_notice/selectors/search_tag_selectors.dart';

class SearchScraper {
  late String baseUrl;
  late String collectionType;

  SearchScraper() {
    baseUrl = dotenv.get('SEARCH_URL');
    collectionType = dotenv.get('COLLECTION');
  }

  Future<Map<String, dynamic>> fetchNotices(
      String query, int startCount) async {
    try {
      // 크롤링 진행
      final String connectUrl =
          '$baseUrl?query=$query&collection=$collectionType&startCount=$startCount';
      final response = await http.get(Uri.parse(connectUrl));

      if (response.statusCode == StatusCodeSettings.kStatusOkay) {
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

  List<Map<String, dynamic>> fetchSearchedNotices(document) {
    final notices = document.querySelectorAll(NoticeTagSelectors.kNoticeBoard);
    final List<Map<String, String>> results = [];

    for (var notice in notices) {
      final titleTag = notice.querySelector(NoticeTagSelectors.kNoticeTitle);
      final bodyTag = notice.querySelector(NoticeTagSelectors.kNoticeBody);
      final dateTag = notice.querySelector(NoticeTagSelectors.kNoticeDate);

      if (titleTag == null || bodyTag == null || dateTag == null) {
        continue;
      }

      final postUrl = titleTag.attributes[NoticeTagSelectors.kNoticeTitleHref];

      final id = makeUniqueNoticeId(postUrl);
      final title = titleTag.text?.trim() ?? '';
      final body = bodyTag.text?.trim() ?? '';
      final link = postUrl;
      final date = dateTag.text.trim();

      results.add(
          {'id': id, 'title': title, 'body': body, 'link': link, 'date': date});
    }
    return results;
  }

  List<Map<String, dynamic>> fetchPages(document) {
    final List<Map<String, dynamic>> results = [];
    final pages = document.querySelectorAll(PageTagSelectors.kPageBoard);
    if (pages.isEmpty) return results;

    final String? lastPageOnClick = pages.last.attributes['onclick'];
    if (lastPageOnClick == null) return results;

    final match = RegExp(r"doPaging\('(\d+)'\)").firstMatch(lastPageOnClick);
    int lastPage = int.parse(match?.group(1) ?? '1');
    if (lastPage != 1) {
      lastPage = lastPage ~/ 10 + 1;
      // 최대 10페이지로 제한
      lastPage = (lastPage > 10) ? 10 : lastPage;
    }
    for (int i = 1; i <= lastPage; i++) {
      final int page = i;
      final int startCount = (i - 1) * 10;
      final bool isCurrent = (i == 1) ? true : false;
      results.add(
          {'page': page, 'startCount': startCount, 'isCurrent': isCurrent});
    }
    return results;
  }

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
