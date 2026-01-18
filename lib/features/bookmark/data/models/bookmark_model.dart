/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-18
 */

import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/features/bookmark/domain/entities/bookmark_entity.dart';

class BookmarkModel extends BookmarkEntity {
  const BookmarkModel({required super.bookmarks});

  factory BookmarkModel.fromList(List<Map<String, dynamic>> list) {
    final List<NoticeTileModel> convertedList = list.map((map) {
      return NoticeTileModel.fromMap(map);
    }).toList();

    return BookmarkModel(bookmarks: convertedList);
  }
}
