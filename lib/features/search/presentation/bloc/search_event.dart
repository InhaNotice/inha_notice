/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-19
 */

import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// 화면 진입 시 초기 데이터(인기 검색어, 최근 검색어) 로드
class LoadSearchEvent extends SearchEvent {}

/// 검색 수행 (최근 검색어 추가)
class AddRecentSearchWordEvent extends SearchEvent {
  final String query;
  AddRecentSearchWordEvent({required this.query});
}

/// 특정 최근 검색어 삭제
class RemoveRecentSearchWordEvent extends SearchEvent {
  final String query;
  RemoveRecentSearchWordEvent({required this.query});
}

/// 최근 검색어 전체 삭제
class ClearRecentSearchWordsEvent extends SearchEvent {}
