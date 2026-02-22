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

abstract class SearchResultEvent extends Equatable {
  const SearchResultEvent();

  @override
  List<Object> get props => [];
}

class SearchNoticesRequestedEvent extends SearchResultEvent {
  final String query;
  final int startCount;
  final String sortType;

  const SearchNoticesRequestedEvent({
    required this.query,
    required this.startCount,
    required this.sortType,
  });

  @override
  List<Object> get props => [query, startCount, sortType];
}

class SearchPageChangedEvent extends SearchResultEvent {
  final int startCount;

  const SearchPageChangedEvent({required this.startCount});

  @override
  List<Object> get props => [startCount];
}

class SearchSortChangedEvent extends SearchResultEvent {
  final String sortType;

  const SearchSortChangedEvent({required this.sortType});

  @override
  List<Object> get props => [sortType];
}
