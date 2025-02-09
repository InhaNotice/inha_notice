import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';

class ThemedSnackbar {
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).snackBarTextColor,
          ),
        ),
        backgroundColor: Theme.of(context).snackBarBackgroundColor,
      ),
    );
  }
}
