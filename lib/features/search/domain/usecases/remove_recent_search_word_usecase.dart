/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-19
 */

import 'package:inha_notice/features/search/domain/repositories/search_repository.dart';

class RemoveRecentSearchWordUseCase {
  final SearchRepository repository;
  RemoveRecentSearchWordUseCase(this.repository);
  Future<void> call(String query) => repository.removeRecentSearchWord(query);
}
