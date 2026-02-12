/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/features/notice/domain/entities/notice_board_entity.dart';

/// **NoticeBoardModel**
/// NoticeBoardEntity를 상속하는 데이터 모델입니다.
class NoticeBoardModel extends NoticeBoardEntity {
  const NoticeBoardModel({
    required super.headlineNotices,
    required super.generalNotices,
    required super.pages,
  });

  factory NoticeBoardModel.fromRaw(Map<String, dynamic> raw) {
    final List<dynamic> rawHeadline = raw['headline'] ?? [];
    final List<dynamic> rawGeneral = raw['general'] ?? [];
    final Pages pages = raw['pages'] ?? createPages();

    return NoticeBoardModel(
      headlineNotices: rawHeadline
          .map((e) => NoticeTileModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      generalNotices: rawGeneral
          .map((e) => NoticeTileModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      pages: pages,
    );
  }
}
