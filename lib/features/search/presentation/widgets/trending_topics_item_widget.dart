/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-19
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/config/app_font.dart';
import 'package:inha_notice/features/search/domain/entities/trending_topic_entity.dart';
import 'package:inha_notice/features/search/presentation/pages/search_result_page.dart';

class TrendingTopicsItemWidget extends StatelessWidget {
  final int rank;
  final TrendingTopicEntity topic;

  const TrendingTopicsItemWidget({
    super.key,
    required this.topic,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SearchResultPage(query: topic.text, isSearchResultPage: true),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // 순위 출력
            Text(
              '$rank',
              style: TextStyle(
                fontFamily: AppFont.pretendard.family,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(width: 16),
            // 검색어에만 회전 효과 적용
            Expanded(
              child: Text(
                topic.text,
                style: TextStyle(
                  fontFamily: AppFont.pretendard.family,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            // 상승/하락 아이콘 및 값 출력
            if (topic.updown == 'U')
              Row(
                children: [
                  const Icon(Icons.arrow_upward, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    topic.count, // 상승 수치
                    style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            if (topic.updown == 'D')
              Row(
                children: [
                  const Icon(Icons.arrow_downward,
                      color: Colors.blue, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    topic.count, // 하락 수치
                    style: TextStyle(
                      fontFamily: AppFont.pretendard.family,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
