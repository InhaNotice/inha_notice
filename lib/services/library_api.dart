import 'dart:convert';
import 'package:http/http.dart' as http;

class LibraryAPI {
  Future<Map<String, dynamic>> fetchNoticesWithLinks(String offset) async {
    try {
      const String inhaAPI = "https://lib.inha.ac.kr/pyxis-api/1/bulletin-boards/1/bulletins";
      const String connectUrl = "https://lib.inha.ac.kr/guide/bulletins/notice";

      Future<List<Map<String, String>>> fetchNotices(Map<String, String> params) async {
        var uri = Uri.parse(inhaAPI).replace(queryParameters: params);
        var response = await http.get(uri);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final notices = data["data"]?["list"] as List<dynamic>?;

          if (notices != null && notices.isNotEmpty) {
            List<Map<String, String>> noticeList = [];
            for (var notice in notices) {
              if (notice is Map<String, dynamic>) {
                final title = notice['title'] ?? 'No Title';
                final id = notice['id'];
                final link = id != null ? "$connectUrl/$id" : null;
                if (link != null) {
                  noticeList.add({
                    'title': title.toString(),
                    'link': link.toString(),
                  });
                }
              }
            }
            return noticeList;
          }
        } else {
          throw Exception('Failed to load notices: ${response.statusCode}');
        }

        return []; // 빈 리스트 반환
      }

      // 중요 공지사항
      final Map<String, String> headlineParams = {
        "onlyNoticableBulletin": "true",
      };
      final List<Map<String, String>> headlineNotices = await fetchNotices(headlineParams);

      // 일반 공지사항
      final Map<String, String> generalParams = {
        "onlyNoticableBulletin": "false",
        "nameOption": "",
        "onlyWriter": "false",
        "max": "10",
        "offset": offset,
      };
      final List<Map<String, String>> generalNotices = await fetchNotices(generalParams);

      // 페이지 번호 생성
      final List<String> setOffsets = List.generate(10, (i) => (i * 10).toString());
      int count = 0;
      final pages = setOffsets.map((setOffset) {
        count += 1;
        final isCurrent = count == 1; // 첫 번째 페이지를 현재 페이지로 설정
        return {
          'page': count,
          'offset': setOffset,
          'isCurrent': isCurrent,
        };
      }).toList();

      return {
        'headline': headlineNotices,
        'general': generalNotices,
        'pages': pages,
      };
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching notices: $e');
    }
  }
}