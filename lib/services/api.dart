import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class ApiService {
  Future<Map<String, dynamic>> fetchNoticesWithLinks(String url, String name, {int page = 1}) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parse(response.body);

        // headline 공지사항
        final headlineElements = document.querySelectorAll(
            '.artclTable .headline ._artclTdTitle a'); // headline CSS 셀렉터
        final headlineNotices = headlineElements.map((element) {
          final title = element.querySelector('strong')?.text.trim() ?? '';
          String link = "";
          if(name == "swcore") {
            link = 'https://swuniv.inha.ac.kr' +
                (element.attributes['href'] ?? '');
          } else if (name == "cse") {
            link = 'https://cse.inha.ac.kr' +
                (element.attributes['href'] ?? '');
          } else {
            link = "";
          }
          return {'title': title, 'link': link};
        }).toList();

        // 일반 공지사항
        final generalElements = document.querySelectorAll(
            '.artclTable tr:not(.headline)');

        // 첫 번째 <tr> 태그(테이블 헤더)를 제외
        final generalNotices = generalElements.skip(1).map((element) {
          final title = element.querySelector('._artclTdTitle a strong')?.text.trim() ?? '';
          String link = "";
          if (name == "swcore") {
            link = 'https://swuniv.inha.ac.kr' +
                (element.querySelector('._artclTdTitle a')?.attributes['href'] ?? '');
          } else if (name == "cse") {
            link = 'https://cse.inha.ac.kr' +
                (element.querySelector('._artclTdTitle a')?.attributes['href'] ?? '');
          } else {
            link = "";
          }
          return {'title': title, 'link': link};
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