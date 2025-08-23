/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-23
 */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:inha_notice/core/constants/status_code_constant.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

/// **TrendingTopicsAPI**
/// 이 클래스는 인하대학교 실시간 인기 검색어를 크롤링하는 API를 정의하는 클래스입니다.
class TrendingTopicsAPI {
  late final String baseUrl;

  TrendingTopicsAPI() {
    baseUrl = dotenv.get("TRENDING_TOPICS_URL");
  }

  /// **실시간 인기 검색어 크롤링 요청을 보냅니다**
  Future<List<Map<String, dynamic>>> fetchTrendingTopics() async {
    try {
      final url = Uri.parse(baseUrl);
      var response = await http.get(url);

      if (response.statusCode == StatusCodeConstant.kStatusOkay) {
        // Xml 문서 형식의 응답 객체를 파싱
        final document = XmlDocument.parse(response.body);
        String makeTime = document.findAllElements('MakeTime').first.innerText;
        DateTime dateTime = DateTime.parse(makeTime);
        makeTime = DateFormat('HH:mm').format(dateTime);

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
