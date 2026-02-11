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
import 'package:inha_notice/core/presentation/models/notice_tile_model.dart';
import 'package:inha_notice/core/presentation/models/pages_model.dart';

abstract class NoticeBoardState extends Equatable {
  const NoticeBoardState();

  @override
  List<Object?> get props => [];
}

class NoticeBoardInitial extends NoticeBoardState {}

class NoticeBoardLoading extends NoticeBoardState {}

class NoticeBoardLoaded extends NoticeBoardState {
  final List<NoticeTileModel> headlineNotices;
  final List<NoticeTileModel> generalNotices;
  final Pages pages;
  final int currentPage;
  final bool isHeadlineSelected;
  final bool isKeywordSearchable;
  final bool isRefreshing;

  const NoticeBoardLoaded({
    required this.headlineNotices,
    required this.generalNotices,
    required this.pages,
    required this.currentPage,
    this.isHeadlineSelected = false,
    this.isKeywordSearchable = false,
    this.isRefreshing = false,
  });

  NoticeBoardLoaded copyWith({
    List<NoticeTileModel>? headlineNotices,
    List<NoticeTileModel>? generalNotices,
    Pages? pages,
    int? currentPage,
    bool? isHeadlineSelected,
    bool? isKeywordSearchable,
    bool? isRefreshing,
  }) {
    return NoticeBoardLoaded(
      headlineNotices: headlineNotices ?? this.headlineNotices,
      generalNotices: generalNotices ?? this.generalNotices,
      pages: pages ?? this.pages,
      currentPage: currentPage ?? this.currentPage,
      isHeadlineSelected: isHeadlineSelected ?? this.isHeadlineSelected,
      isKeywordSearchable: isKeywordSearchable ?? this.isKeywordSearchable,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
        headlineNotices,
        generalNotices,
        pages,
        currentPage,
        isHeadlineSelected,
        isKeywordSearchable,
        isRefreshing,
      ];
}

/// 유저 설정이 필요한 경우 (학과, 단과대, 대학원)
class NoticeBoardSettingRequired extends NoticeBoardState {
  final String noticeType;
  final String? displayName;

  const NoticeBoardSettingRequired({
    required this.noticeType,
    this.displayName,
  });

  @override
  List<Object?> get props => [noticeType, displayName];
}

class NoticeBoardError extends NoticeBoardState {
  final String message;

  const NoticeBoardError({required this.message});

  @override
  List<Object?> get props => [message];
}
