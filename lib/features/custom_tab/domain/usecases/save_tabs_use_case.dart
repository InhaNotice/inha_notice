/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-11
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/features/custom_tab/domain/failures/custom_tab_failure.dart';
import 'package:inha_notice/features/custom_tab/domain/repositories/custom_tab_repository.dart';

class SaveTabsUseCase {
  final CustomTabRepository repository;

  SaveTabsUseCase({required this.repository});

  Future<Either<CustomTabFailure, Unit>> call(List<String> tabs) async {
    return await repository.saveTabs(tabs);
  }
}
