/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-18
 */

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:inha_notice/features/bookmark/domain/entities/bookmark_sorting_type.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object> get props => [];
}

class LoadBookmarksEvent extends BookmarkEvent {
  final bool isRefresh;
  final Completer? completer;

  const LoadBookmarksEvent({required this.isRefresh, this.completer});
}

class RemoveBookmarkEvent extends BookmarkEvent {
  final int id;

  const RemoveBookmarkEvent({required this.id});
}

class ChangeSortingEvent extends BookmarkEvent {
  final BookmarkSortingType sortType;

  const ChangeSortingEvent({required this.sortType});
}

class ClearBookmarksEvent extends BookmarkEvent {}
