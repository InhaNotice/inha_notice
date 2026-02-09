/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-09
 */

import 'package:equatable/equatable.dart';

abstract class NoticeBoardEvent extends Equatable {
  const NoticeBoardEvent();

  @override
  List<Object?> get props => [];
}

/// 공지사항을 초기 로드합니다.
class LoadNoticeBoardEvent extends NoticeBoardEvent {
  final String noticeType;

  const LoadNoticeBoardEvent({required this.noticeType});

  @override
  List<Object?> get props => [noticeType];
}

/// 특정 페이지의 공지사항을 로드합니다. (Absolute 스타일)
class LoadPageEvent extends NoticeBoardEvent {
  final int page;
  final String? searchColumn;
  final String? searchWord;

  const LoadPageEvent({
    required this.page,
    this.searchColumn,
    this.searchWord,
  });

  @override
  List<Object?> get props => [page, searchColumn, searchWord];
}

/// 특정 오프셋의 공지사항을 로드합니다. (Relative 스타일)
class LoadOffsetEvent extends NoticeBoardEvent {
  final int offset;

  const LoadOffsetEvent({required this.offset});

  @override
  List<Object?> get props => [offset];
}

/// 중요/일반 공지 토글
class ToggleNoticeTypeEvent extends NoticeBoardEvent {
  final bool isHeadline;

  const ToggleNoticeTypeEvent({required this.isHeadline});

  @override
  List<Object?> get props => [isHeadline];
}

/// 키워드 검색
class SearchByKeywordEvent extends NoticeBoardEvent {
  final String searchColumn;
  final String searchWord;

  const SearchByKeywordEvent({
    required this.searchColumn,
    required this.searchWord,
  });

  @override
  List<Object?> get props => [searchColumn, searchWord];
}

/// 새로고침
class RefreshNoticeBoardEvent extends NoticeBoardEvent {
  const RefreshNoticeBoardEvent();
}

/// 공지 읽음 처리
class MarkNoticeAsReadEvent extends NoticeBoardEvent {
  final String noticeId;

  const MarkNoticeAsReadEvent({required this.noticeId});

  @override
  List<Object?> get props => [noticeId];
}
