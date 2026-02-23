/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-23
 */

import 'package:equatable/equatable.dart';
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';

abstract class SearchResultState extends Equatable {
  const SearchResultState();

  @override
  List<Object?> get props => [];
}

class SearchResultInitial extends SearchResultState {}

class SearchResultLoading extends SearchResultState {}

class SearchResultLoaded extends SearchResultState {
  final List<NoticeTileModel> notices;
  final Pages pages;
  final int currentPage;
  final SearchResultDefaultSortType sortType;
  final bool isRefreshing;

  const SearchResultLoaded({
    required this.notices,
    required this.pages,
    required this.currentPage,
    required this.sortType,
    this.isRefreshing = false,
  });

  SearchResultLoaded copyWith({
    List<NoticeTileModel>? notices,
    Pages? pages,
    int? currentPage,
    SearchResultDefaultSortType? sortType,
    bool? isRefreshing,
  }) {
    return SearchResultLoaded(
      notices: notices ?? this.notices,
      pages: pages ?? this.pages,
      currentPage: currentPage ?? this.currentPage,
      sortType: sortType ?? this.sortType,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
        notices,
        pages,
        currentPage,
        sortType,
        isRefreshing,
      ];
}

class SearchResultError extends SearchResultState {
  final String message;

  const SearchResultError({required this.message});

  @override
  List<Object?> get props => [message];
}
