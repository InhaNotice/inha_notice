/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-08
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:inha_notice/features/more/data/models/oss_license_category_model.dart';
import 'package:inha_notice/features/more/data/models/oss_license_item_model.dart';

abstract class OssLicenseLocalDataSource {
  Future<List<OssLicenseCategoryModel>> getOssLicenses();
}

class OssLicenseLocalDataSourceImpl implements OssLicenseLocalDataSource {
  @override
  Future<List<OssLicenseCategoryModel>> getOssLicenses() async {
    final String jsonString =
        await rootBundle.loadString('assets/licenses/licenses.json');

    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<OssLicenseCategoryModel> categories = [];

    jsonMap.forEach((categoryName, packages) {
      if (packages is Map<String, dynamic>) {
        final List<OssLicenseItemModel> items = [];
        packages.forEach((packageName, licenseText) {
          items.add(OssLicenseItemModel(
            packageName: packageName,
            licenseText: licenseText.toString(),
          ));
        });
        categories.add(OssLicenseCategoryModel(
          categoryName: categoryName,
          items: items,
        ));
      }
    });
    return categories;
  }
}
