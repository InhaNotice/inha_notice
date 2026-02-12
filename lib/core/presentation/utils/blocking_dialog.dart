/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

import 'package:flutter/material.dart';
import 'package:inha_notice/core/presentation/widgets/blue_loading_indicator_widget.dart';

class BlockingDialog {
  BlockingDialog._();

  /// **사용자가 닫을 수 없는 다이얼로그 표시**
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 사용자가 닫을 수 없도록 설정
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(child: BlueLoadingIndicatorWidget()),
        );
      },
    );
  }

  /// **다이얼로그 닫기**
  static void dismiss(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
