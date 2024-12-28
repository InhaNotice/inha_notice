import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class ApiService {
  Future<List<Map<String, String>>> fetchNoticesWithLinks(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parse(response.body);
        final noticeElements = document.querySelectorAll(
            '.artclTable ._artclTdTitle a'); // CSS 셀렉터 수정 가능

        return noticeElements.map((element) {
          final title = element.querySelector('strong')?.text.trim() ?? '';
          final link = 'https://swuniv.inha.ac.kr' +
              (element.attributes['href'] ?? ''); // 상대 경로 처리
          return {'title': title, 'link': link};
        }).toList();
      } else {
        throw Exception('Failed to load notices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notices: $e');
    }
  }
}