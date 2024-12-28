import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class ApiService {
  // 공지사항 제목과 링크를 가져오는 메서드
  Future<List<Map<String, String>>> fetchNoticesWithLinks() async {
    const url = 'https://cse.inha.ac.kr/cse/888/subview.do'; // 공지사항 URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parse(response.body);

        // 공지사항 제목과 링크 선택
        final noticeElements = document.querySelectorAll(
            '.artclTable ._artclTdTitle a');

        return noticeElements.map((element) {
          final title = element.querySelector('strong')?.text.trim() ?? '';
          final link = 'https://cse.inha.ac.kr' +
              (element.attributes['href'] ?? ''); // 상대 경로를 절대 경로로 변환
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