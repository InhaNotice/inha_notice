/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-12-25
 */

import 'package:dartz/dartz.dart';
import 'package:inha_notice/core/error/failures.dart';
import 'package:inha_notice/features/notice/domain/entities/home_tab_entity.dart';

abstract class HomeRepository {
  Future<Either<HomeFailure, List<HomeTabEntity>>> getHomeTabs();
}
