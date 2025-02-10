/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-10
 */
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:inha_notice/constants/status_code_constants.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class TrendingTopicsAPI {
  late final String baseUrl;

  TrendingTopicsAPI() {
    baseUrl = dotenv.get("TRENDING_TOPICS_URL");
  }

  Future<List<Map<String, dynamic>>> fetchTrendingTopics() async {
    try {
      final url = Uri.parse(baseUrl);
      var response = await http.get(url);

      if (response.statusCode == StatusCodeSettings.kStatusOkay) {
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
