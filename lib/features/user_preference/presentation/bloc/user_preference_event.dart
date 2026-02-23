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

abstract class UserPreferenceEvent extends Equatable {
  const UserPreferenceEvent();

  @override
  List<Object> get props => [];
}

class LoadUserPreferenceEvent extends UserPreferenceEvent {
  const LoadUserPreferenceEvent();
}

class UpdateNoticeBoardDefaultEvent extends UserPreferenceEvent {
  final NoticeBoardDefaultType type;

  const UpdateNoticeBoardDefaultEvent({required this.type});

  @override
  List<Object> get props => [type];
}

class UpdateBookmarkDefaultSortEvent extends UserPreferenceEvent {
  final BookmarkDefaultSortType type;

  const UpdateBookmarkDefaultSortEvent({required this.type});

  @override
  List<Object> get props => [type];
}

class UpdateSearchResultDefaultSortEvent extends UserPreferenceEvent {
  final SearchResultDefaultSortType type;

  const UpdateSearchResultDefaultSortEvent({required this.type});

  @override
  List<Object> get props => [type];
}
