/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'package:equatable/equatable.dart';
import 'package:inha_notice/features/user_preference/domain/entities/bookmark_default_sort_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/notice_board_default_type.dart';
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';

class UserPreferenceEntity extends Equatable {
  final NoticeBoardDefaultType noticeBoardDefault;
  final BookmarkDefaultSortType bookmarkDefaultSort;
  final SearchResultDefaultSortType searchResultDefaultSort;

  const UserPreferenceEntity({
    required this.noticeBoardDefault,
    required this.bookmarkDefaultSort,
    required this.searchResultDefaultSort,
  });

  @override
  List<Object?> get props => [
        noticeBoardDefault,
        bookmarkDefaultSort,
        searchResultDefaultSort,
      ];
}
