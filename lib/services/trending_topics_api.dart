import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class TrendingTopicsAPI {
  late final String baseUrl;

  TrendingTopicsAPI() {
    baseUrl = dotenv.get("SEARCH_URL");
  }

  Future<List<Map<String, dynamic>>> fetchTrendingTopics() async {
    try {
      // 요청 URL 및 파라미터 설정
      final Map<String, String> requestBody = {
        "target": "popword",
        "collection": "_ALL_",
        "range": "pop_day",
      };

      // HTTP GET 요청
      var uri = Uri.parse(baseUrl).replace(queryParameters: requestBody);
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final makeTime = document.findAllElements('MakeTime').first.innerText;
        final queries = document.findAllElements('Query').map((node) {
          final id = node.getAttribute('id');
          final queryCount = node.getAttribute('querycount');
          final count = node.getAttribute('count');
          final updown = node.getAttribute('updown');
          final text = node.innerText;

          return {
            'id': id,
            'queryCount': queryCount,
            'count': count,
            'updown': updown,
            'text': text,
            'makeTimes': makeTime
          };
        }).toList();
        return queries;
      } else {
        throw Exception('Failed to load board page: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notices: $e');
    }
  }
}

