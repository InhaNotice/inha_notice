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
import 'package:inha_notice/features/bookmark/domain/entities/bookmark_sorting_type.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<NoticeTileModel> bookmarks;
  final BookmarkSortingType sortType;

  const BookmarkLoaded({required this.bookmarks, required this.sortType});

  @override
  List<Object?> get props => [bookmarks, sortType];
}

class BookmarkError extends BookmarkState {
  final String message;

  const BookmarkError({required this.message});

  @override
  List<Object?> get props => [message];
}
