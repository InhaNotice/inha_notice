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

/// **NoticeBoardEntity**
/// 공지사항 게시판의 데이터를 담는 도메인 엔티티입니다.
class NoticeBoardEntity extends Equatable {
  final List<NoticeTileModel> headlineNotices;
  final List<NoticeTileModel> generalNotices;
  final Pages pages;

  const NoticeBoardEntity({
    required this.headlineNotices,
    required this.generalNotices,
    required this.pages,
  });

  @override
  List<Object?> get props => [headlineNotices, generalNotices, pages];
}
