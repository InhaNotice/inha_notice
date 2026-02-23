/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-23
 */

import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/features/search/domain/entities/search_result_entity.dart';

/// **SearchResultModel**
/// SearchResultEntity를 상속하는 데이터 모델입니다.
class SearchResultModel extends SearchResultEntity {
  const SearchResultModel({
    required super.notices,
    required super.pages,
  });

  factory SearchResultModel.fromRaw(Map<String, dynamic> raw) {
    final List<dynamic> rawGeneral = raw['general'] ?? [];
    final Pages pages = raw['pages'] ?? createPages();

    return SearchResultModel(
      notices: rawGeneral
          .map((e) => NoticeTileModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      pages: pages,
    );
  }
}
