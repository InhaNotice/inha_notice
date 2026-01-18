/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-18
 */

import 'package:equatable/equatable.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';

class BookmarkEntity extends Equatable {
  final List<NoticeTileModel> bookmarks;

  const BookmarkEntity({required this.bookmarks});

  @override
  List<Object?> get props => [bookmarks];
}
