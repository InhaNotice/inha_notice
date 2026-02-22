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
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';

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
  final String query;
  final int currentPage;
  final String sortType;

  const SearchResultLoaded({
    required this.notices,
    required this.pages,
    required this.query,
    required this.currentPage,
    required this.sortType,
  });

  @override
  List<Object?> get props => [notices, pages, query, currentPage, sortType];
}

class SearchResultError extends SearchResultState {
  final String message;

  const SearchResultError({required this.message});

  @override
  List<Object?> get props => [message];
}
