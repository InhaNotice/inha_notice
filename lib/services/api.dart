import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class ApiService {
  Future<Map<String, List<Map<String, String>>>> fetchNoticesWithLinks(
      String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parse(response.body);

        // headline 공지사항
        final headlineElements = document.querySelectorAll(
            '.artclTable .headline ._artclTdTitle a'); // headline CSS 셀렉터
        final headlineNotices = headlineElements.map((element) {
          final title = element.querySelector('strong')?.text.trim() ?? '';
          final link = 'https://swuniv.inha.ac.kr' +
              (element.attributes['href'] ?? '');
          return {'title': title, 'link': link};
        }).toList();

        // 일반 공지사항
        final generalElements = document.querySelectorAll(
            '.artclTable ._artclTdTitle:not(.headline) a'); // 일반 공지사항 CSS 셀렉터
        final generalNotices = generalElements.map((element) {
          final title = element.querySelector('strong')?.text.trim() ?? '';
          final link = 'https://swuniv.inha.ac.kr' +
              (element.attributes['href'] ?? '');
          return {'title': title, 'link': link};
        }).toList();

        return {
          'headline': headlineNotices,
          'general': generalNotices,
        };
      } else {
        throw Exception('Failed to load notices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notices: $e');
    }
  }
}