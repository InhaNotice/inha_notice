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
import 'package:inha_notice/features/search/domain/failures/search_failure.dart';
import 'package:inha_notice/features/search/domain/repositories/search_repository.dart';

class ClearRecentSearchWordsUseCase {
  final SearchRepository repository;
  ClearRecentSearchWordsUseCase(this.repository);

  Future<Either<SearchFailure, void>> call() async {
    return await repository.clearRecentSearchWords();
  }
}
