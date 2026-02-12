/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inha_notice/features/more/data/models/more_configuration_model.dart';

abstract class MoreLocalDataSource {
  Future<MoreConfigurationModel> getWebUrls();
}

class MoreLocalDataSourceImpl implements MoreLocalDataSource {
  @override
  Future<MoreConfigurationModel> getWebUrls() async {
    return MoreConfigurationModel(
        appVersion: dotenv.get('APP_VERSION'),
        featuresUrl: dotenv.get('FEATURES_URL'),
        personalInformationUrl: dotenv.get('PERSONAL_INFORMATION_URL'),
        termsAndConditionsOfServiceUrl:
            dotenv.get('TERMS_AND_CONDITIONS_OF_SERVICE_URL'),
        introduceAppUrl: dotenv.get('INTRODUCE_APP_URL'),
        questionsAndAnswersUrl: dotenv.get('QUESTIONS_AND_ANSWERS_URL'));
  }
}
