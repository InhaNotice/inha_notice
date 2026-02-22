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

class SearchResultEntity extends Equatable {
  final List<NoticeTileModel> notices;
  final Pages pages;

  const SearchResultEntity({
    required this.notices,
    required this.pages,
  });

  @override
  List<Object?> get props => [notices, pages];
}
