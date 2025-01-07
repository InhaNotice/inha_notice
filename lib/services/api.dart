import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class ApiService {
  Future<Map<String, dynamic>> fetchNoticesWithLinks(String url, String name, {int page = 1}) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parse(response.body);
        // name과 도메인 매핑
        final domainMap = {
          "cse": "https://cse.inha.ac.kr",
          "internal": "https://internationalcenter.inha.ac.kr"
        };

        // headline 공지사항
        final headlineElements = document.querySelectorAll(
            '.artclTable .headline ._artclTdTitle a');
        final headlineNotices = headlineElements.map((element) {
          final title = element.querySelector('strong')?.text.trim() ?? '';
          final baseUrl = domainMap[name] ?? "";
          final postUrl = element.attributes['href'] ?? '';
          final link = baseUrl + postUrl;

          List<String> parts = postUrl.split('/');
          String postId = (parts.length > 4) ? parts[4] :'unknown';

          return {'title': title, 'link': link, 'postId': postId};
        }).toList();

        // 일반 공지사항
        final generalElements = document.querySelectorAll(
            '.artclTable tr:not(.headline)');

        // 첫 번째 <tr> 태그(테이블 헤더)를 제외
        final generalNotices = generalElements.skip(1).map((element) {
          final title = element.querySelector('._artclTdTitle a strong')?.text.trim() ?? '';
          final baseUrl = domainMap[name] ?? ""; // name에 따라 도메인 결정
          final postUrl = element.querySelector('._artclTdTitle a')?.attributes['href'] ?? '';
          final link = baseUrl + postUrl;

          List<String> parts = postUrl.split('/');
          String postId = (parts.length > 4) ? parts[4] :'unknown';

          return {'title': title, 'link': link, 'postId': postId};
        }).toList();

        // 페이지 번호 크롤링
        final pageElements = document.querySelectorAll('._paging ._inner ul li');
        final pages = pageElements.map((element) {
          final isCurrent = element.localName == 'strong'; // 현재 페이지는 <strong> 태그
          return {
            'page': element.text.trim(),
            'isCurrent': isCurrent,
          };
        }).toList();

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
}