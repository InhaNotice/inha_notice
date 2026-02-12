/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/bookmark/domain/failures/bookmark_failure.dart';
import 'package:inha_notice/features/bookmark/domain/repositories/bookmark_repository.dart';

class ClearBookmarksUseCase {
  final BookmarkRepository repository;

  ClearBookmarksUseCase({required this.repository});

  Future<Either<BookmarkFailure, void>> call() async {
    return await repository.clearBookmarks();
  }
}
