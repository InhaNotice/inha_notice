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
import 'package:inha_notice/features/user_preference/domain/entities/search_result_default_sort_type.dart';

abstract class SearchResultEvent extends Equatable {
  const SearchResultEvent();

  @override
  List<Object?> get props => [];
}

/// 검색 결과를 초기 로드합니다.
class LoadSearchResultEvent extends SearchResultEvent {
  final String query;

  const LoadSearchResultEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

/// 정렬 타입을 변경합니다.
class ChangeSortTypeEvent extends SearchResultEvent {
  final SearchResultDefaultSortType sortType;

  const ChangeSortTypeEvent({required this.sortType});

  @override
  List<Object?> get props => [sortType];
}

/// 특정 오프셋의 페이지를 로드합니다.
class LoadPageEvent extends SearchResultEvent {
  final int offset;

  const LoadPageEvent({required this.offset});

  @override
  List<Object?> get props => [offset];
}

/// 새로고침합니다.
class RefreshSearchResultEvent extends SearchResultEvent {
  const RefreshSearchResultEvent();
}

/// 공지 읽음 처리합니다.
class MarkNoticeAsReadEvent extends SearchResultEvent {
  final String noticeId;

  const MarkNoticeAsReadEvent({required this.noticeId});

  @override
  List<Object?> get props => [noticeId];
}
