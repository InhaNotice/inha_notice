/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-23
 */

/// **NotificationTileMajorItem**
/// 단일 학과에 대한 모델을 정의한다.
class NotificationMajorItem {
  final String title;
  final String key;
  final String topic;

  NotificationMajorItem({
    required this.title,
    required this.key,
    required this.topic,
  });
}
