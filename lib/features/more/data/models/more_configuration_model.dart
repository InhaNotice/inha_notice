/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-22
 */

import 'package:inha_notice/features/more/domain/entities/more_configuration_entity.dart';

class MoreConfigurationModel extends MoreConfigurationEntity {
  const MoreConfigurationModel({
    required super.appVersion,
    required super.featuresUrl,
    required super.personalInformationUrl,
    required super.termsAndConditionsOfServiceUrl,
    required super.introduceAppUrl,
    required super.questionsAndAnswersUrl,
  });
}
