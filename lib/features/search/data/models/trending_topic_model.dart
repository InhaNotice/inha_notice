/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:inha_notice/features/search/domain/entities/trending_topic_entity.dart';

class TrendingTopicModel extends TrendingTopicEntity {
  const TrendingTopicModel({
    required super.id,
    required super.queryCount,
    required super.count,
    required super.updown,
    required super.text,
    required super.makeTimes,
  });

  factory TrendingTopicModel.fromMap(Map<String, dynamic> map) {
    return TrendingTopicModel(
        id: map['id'] ?? '',
        queryCount: map['queryCount'] ?? '',
        count: map['count'] ?? '',
        updown: map['updown'] ?? '',
        text: map['text'] ?? '',
        makeTimes: map['makeTimes'] ?? '');
  }

  static List<TrendingTopicModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((item) {
      return TrendingTopicModel.fromMap(item);
    }).toList();
  }
}
