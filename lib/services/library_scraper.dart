import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:inha_notice/constants/status_code_constants.dart';

class LibraryScraper {
  late String baseUrl;
  late String queryUrl;

  LibraryScraper() {
    baseUrl = dotenv.get('LIBRARY_URL');
    queryUrl = dotenv.get('LIBRARY_QUERY_URL');
  }

  Future<Map<String, dynamic>> fetchNotices(int offset) async {
    try {
      // 중요 공지사항 매개변수
      final Map<String, String> headlineParams = {
        "onlyNoticableBulletin": "true",
      };

      // 일반 공지사항 매개변수
      final Map<String, String> generalParams = {
        "onlyNoticableBulletin": "false",
        "nameOption": "",
        "onlyWriter": "false",
        "max": "10",
        "offset": offset.toString(),
      };

      // 중요 공지사항 가져오기
      final List<Map<String, String>> headlineNotices =
          await fetchNoticesWithParams(headlineParams);

      // 일반 공지사항 가져오기
      final List<Map<String, String>> generalNotices =
          await fetchNoticesWithParams(generalParams);

      final pages = fetchPages();

      return {
        'headline': headlineNotices,
        'general': generalNotices,
        'pages': pages,
      };
    } catch (e) {
      throw Exception('Error fetching notices: $e');
    }
  }

  Future<List<Map<String, String>>> fetchNoticesWithParams(
      Map<String, String> params) async {
    var connectUrl = Uri.parse(baseUrl).replace(queryParameters: params);
    var response = await http.get(connectUrl);
    List<Map<String, String>> results = [];

    if (response.statusCode == StatusCodeSettings.kStatusOkay) {
      final data = json.decode(response.body);
      final List<dynamic> notices = data["data"]?["list"];
      for (var notice in notices) {
        final String postId = notice['id'].toString();

        final String id = makeUniqueNoticeId(postId);
        final String title = notice['title'].toString();
        final String link = '$queryUrl/$postId';
        final String rawDate = notice['lastUpdated'].toString();
        DateTime parsedDate = DateTime.parse(rawDate);
        final String date =
            '${parsedDate.year}.${parsedDate.month.toString().padLeft(2, '0')}.${parsedDate.day.toString().padLeft(2, '0')}';
        final String writer = notice['writer'].toString();
        final String access = notice['hitCnt'].toString();

        results.add({
          'id': id,
          'title': title,
          'link': link,
          'date': date,
          'writer': writer,
          'access': access,
        });
      }
    }
    return results;
  }

  List<Map<String, dynamic>> fetchPages() {
    final List<Map<String, dynamic>> results = [];

    for (int i = 1; i <= 10; i++) {
      final int page = i;
      final int offset = ((i - 1) * 10);
      final bool isCurrent = (i == 1) ? true : false;
      results.add({
        'page': page,
        'offset': offset,
        'isCurrent': isCurrent,
      });
    }
    return results;
  }

  String makeUniqueNoticeId(String postId) {
    const String provider = 'lib';
    final String uniqueNoticeId = '$provider-$postId';
    return uniqueNoticeId;
  }
}
