/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-22
 */

import 'package:equatable/equatable.dart';

class MoreConfigurationEntity extends Equatable {
  final String appVersion;
  final String featuresUrl;
  final String personalInformationUrl;
  final String termsAndConditionsOfServiceUrl;
  final String introduceAppUrl;
  final String questionsAndAnswersUrl;

  const MoreConfigurationEntity({
    required this.appVersion,
    required this.featuresUrl,
    required this.personalInformationUrl,
    required this.termsAndConditionsOfServiceUrl,
    required this.introduceAppUrl,
    required this.questionsAndAnswersUrl,
  });

  @override
  List<Object?> get props => [
        appVersion,
        featuresUrl,
        personalInformationUrl,
        termsAndConditionsOfServiceUrl,
        introduceAppUrl,
        questionsAndAnswersUrl,
      ];
}
