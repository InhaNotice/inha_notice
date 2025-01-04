import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

class SearchAPI {
  Future<Map<String, dynamic>> fetchNoticesWithLinks(String url, String query, {int page = 1}) async {
    try {
      final boardLink = url;

      final boardResponse = await http.get(Uri.parse(boardLink));
      if (boardResponse.statusCode == 200) {
        final document = html_parser.parse(boardResponse.body);

        // 공지사항 크롤링
        final noticesElements = document.querySelectorAll('dl.resultsty_1');
        final notices = noticesElements.map((notice) {
          final titleElement = notice.querySelector('dt > a.tit');
          final link = titleElement?.attributes['href'];
          final title = titleElement?.text.trim() ?? 'No Title';
          return {'title': title, 'link': link ?? ''};
        }).toList();

        // 페이지 정보 크롤링
        final pageElements = document.querySelectorAll('div.btn_num > a.num'); // 모든 페이지네이션 요소 선택
        final currentPageElement = document.querySelector('div.btn_num > a.click > strong'); // 현재 페이지 요소 (<strong> 태그)
        final pages = <Map<String, dynamic>>[];

        pages.add({
          'page': currentPageElement?.text.trim(), // 현재 페이지 번호
          'startCount': '0', // 첫 번째 페이지의 startCount는 항상 0
          'isCurrent': true, // 현재 페이지
        });

        // 나머지 페이지 처리
        pages.addAll(pageElements.where((pageElement) {
          final title = pageElement.attributes['title']; // title 속성 가져오기
          return title == '페이징'; // title="페이징"인 것만 필터링
        }).map((pageElement) {
          final pageNumber = pageElement.text.trim(); // 페이지 번호
          final pageLink = pageElement.attributes['onclick'] ?? ''; // onclick 속성 값
          final match = RegExp(r"doPaging\('(\d+)'\)").firstMatch(pageLink); // doPaging 값 추출
          final startCount = match?.group(1) ?? ''; // null일 경우 기본값 '' 사용
          return {
            'page': pageNumber,
            'startCount': startCount, // 페이지 이동에 필요한 값
            'isCurrent': false, // 나머지 페이지는 기본적으로 false
          };
        }));

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