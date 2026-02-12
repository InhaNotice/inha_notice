/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:inha_notice/core/presentation/models/pages_model.dart';

/// **BaseRelativeStyleNoticeScraper**
/// 이 클래스는 Relative Style의 공지사항 스크래퍼를 정의하는 추상 클래스입니다.
abstract class BaseRelativeStyleNoticeScraper {
  Future<Map<String, dynamic>> fetchNotices(int offset);

  Future<List<Map<String, String>>> fetchNoticesWithParams(
      Map<String, String> params);

  Pages fetchPages();

  String makeUniqueNoticeId(String postId);
}
