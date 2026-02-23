/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-22
 */

import 'dart:io';

import 'package:inha_notice/core/keys/shared_pref_keys.dart';
import 'package:inha_notice/core/utils/shared_prefs_manager.dart';
import 'package:path_provider/path_provider.dart';

abstract class CacheLocalDataSource {
  Future<String> getCacheSize();
}

class CacheLocalDataSourceImpl implements CacheLocalDataSource {
  final SharedPrefsManager sharedPrefsManager;

  CacheLocalDataSourceImpl({required this.sharedPrefsManager});

  @override
  Future<String> getCacheSize() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      int totalBytes = 0;

      if (await directory.exists()) {
        await for (var entity
            in directory.list(recursive: true, followLinks: false)) {
          if (entity is File) {
            totalBytes += await entity.length();
          }
        }
      }

      final double mb = totalBytes / (1024 * 1024);
      final String result = '${mb.toStringAsFixed(2)} MB';

      await sharedPrefsManager.setValue<String>(
          SharedPrefKeys.kCacheCapacity, result);

      return result;
    } catch (e) {
      // 에러 발생 시 "0.00 MB" 반환 혹은 에러 throw
      return '0.00 MB';
    }
  }
}
