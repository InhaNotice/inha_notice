/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-22
 */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_status_code/http_status_code.dart';
import 'package:inha_notice/core/error/exceptions.dart';
import 'package:inha_notice/features/search/data/models/trending_topic_model.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

abstract class SearchRemoteDataSource {
  Future<List<TrendingTopicModel>> getTrendingTopics();
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  late final String baseUrl;

  SearchRemoteDataSourceImpl() {
    baseUrl = dotenv.get("TRENDING_TOPICS_URL");
  }
  @override
  Future<List<TrendingTopicModel>> getTrendingTopics() async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == StatusCode.OK) {
        return _parseTrendingTopicsXml(response.body);
      } else {
        throw ServerException(
            'Failed to load trending topics: ${response.statusCode}');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Error fetching notices: $e');
    }
  }

  /// XML 데이터를 파싱하여 Model 리스트로 변환하는 헬퍼 메서드
  List<TrendingTopicModel> _parseTrendingTopicsXml(String responseBody) {
    final document = XmlDocument.parse(responseBody);

    // MakeTime 파싱 (XML 구조상 상위에 하나만 존재한다고 가정)
    final makeTimeElement = document.findAllElements('MakeTime').firstOrNull;
    String formattedTime = '';

    if (makeTimeElement != null) {
      try {
        final dateTime = DateTime.parse(makeTimeElement.innerText);
        formattedTime = DateFormat('HH:mm').format(dateTime);
      } catch (_) {
        // 날짜 파싱 실패 시 현재 시간 혹은 빈 문자열 등 예외 처리
        formattedTime = DateFormat('HH:mm').format(DateTime.now());
      }
    }

    // Query 태그 파싱
    final queries = document.findAllElements('Query').map((node) {
      return {
        'id': node.getAttribute('id'),
        'queryCount': node.getAttribute('querycount'),
        'count': node.getAttribute('count'),
        'updown': node.getAttribute('updown'),
        'text': node.innerText,
        'makeTimes': formattedTime, // 위에서 파싱한 시간 공통 적용
      };
    }).toList();

    return TrendingTopicModel.fromList(queries);
  }
}
