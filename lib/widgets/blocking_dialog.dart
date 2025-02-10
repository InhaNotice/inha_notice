import 'package:flutter/material.dart';

class BlockingDialog {
  /// **사용자가 닫을 수 없는 다이얼로그 표시**
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 사용자가 닫을 수 없도록 설정
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
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
