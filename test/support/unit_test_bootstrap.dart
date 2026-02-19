/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-18
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void ensureTestBinding() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

Future<SharedPreferences> seedMockPrefs(
  Map<String, Object> initialValues,
) async {
  SharedPreferences.setMockInitialValues(initialValues);
  return SharedPreferences.getInstance();
}

Future<void> resetMockPrefs() async {
  SharedPreferences.setMockInitialValues({});
  await SharedPreferences.getInstance();
}
