/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-24
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:inha_notice/core/presentation/pages/in_app_web_page.dart';

class WebNavigatorWidget {
  static Future<void> navigate(
      {required BuildContext context, required String? url}) async {
    if (Platform.isIOS) {
      Navigator.of(context).push(
        SmoothCupertinoPageRoute(
          builder: (context) => InAppWebPage(url: url ?? ''),
        ),
      );
    } else {
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
}

class SmoothCupertinoPageRoute<T> extends CupertinoPageRoute<T> {
  SmoothCupertinoPageRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);
}
