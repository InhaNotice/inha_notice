/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-17
 */

import 'package:flutter/cupertino.dart';

import 'in_app_web_page.dart';

class WebNavigator {
  /// **사파리 웹 페이지를 띄우는 함수**
  static Future<void> navigate(
      {required BuildContext context, required String? url}) async {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            InAppWebPage(url: url ?? ''),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child; // 애니메이션 없이 바로 전환
        },
      ),
    );
  }
}
