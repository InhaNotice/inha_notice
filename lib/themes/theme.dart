/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-27
 */
import 'package:flutter/material.dart';

/// **화이트 모드 테마**
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black54),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black54,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.grey),
  ),
  primaryColorLight: Colors.blue,
  iconTheme: const IconThemeData(color: Colors.grey),
  dividerColor: Colors.grey[300],
);

/// **다크 모드 테마**
final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF222222),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF222222),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF292929),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.grey),
    ),
    primaryColorLight: Colors.blue,
    iconTheme: const IconThemeData(color: Colors.white),
    dividerColor: const Color(0xFF292929));

/// **DefaultColors**
/// 기본 글자 색상을 정의합니다.
extension DefaultColors on ThemeData {
  Color get defaultThemedTextColor =>
      brightness == Brightness.light ? Colors.black : Colors.white;

  Color get fixedBlueText => Colors.blue;

  Color get fixedLightGreyText =>
      brightness == Brightness.light ? Colors.black54 : Colors.white;

  Color get fixedGreyText => Colors.grey;
}

/// **TextColors**
/// 읽은 공지에 대한 글자 색상을 정의합니다.
extension TextColors on ThemeData {
  Color get readTextColor =>
      brightness == Brightness.light ? Colors.grey : Colors.grey;
}

/// **BorderColors**
/// 공지 타일의 경계 색상을 정의합니다.
extension BorderColors on ThemeData {
  Color get noticeBorderColor => dividerColor;
}

/// **BoxBorderColors**
/// 박스 경계 색상을 정의합니다.
extension BoxBorderColors on ThemeData {
  Color get boxBorderColor =>
      brightness == Brightness.light ? Colors.black26 : Colors.white24;

  Color? get boxTextFieldBackgroundColor =>
      brightness == Brightness.light ? Colors.grey[200] : Colors.grey[700];
}

/// **SnackBarColors**
/// 스낵바 색상을 정의합니다.
extension SnackBarColors on ThemeData {
  Color get snackBarBackgroundColor =>
      brightness == Brightness.light ? Colors.black87 : const Color(0xFF424242);

  Color get snackBarTextColor =>
      brightness == Brightness.light ? Colors.white : Colors.white70;
}

/// **ButtonColors**
/// 버튼 색상을 정의합니다.
extension ButtonColors on ThemeData {
  Color get buttonBackgroundColor =>
      brightness == Brightness.light ? Colors.grey[200]! : Colors.grey[800]!;
}

/// **ToggleColors**
/// 토글 색상을 정의합니다.
extension ToggleColors on ThemeData {
  Color get selectedToggleBorder => Colors.blue;

  Color get unSelectedToggleBorder => Colors.grey;

  Color get selectedToggleText => Colors.blue;

  Color get unSelectedToggleText => Colors.grey;
}

/// **PageButtonColors**
/// 페이지네이션 색상을 정의합니다.
extension PageButtonColors on ThemeData {
  Color get selectedPageButtonTextColor =>
      textTheme.bodyMedium?.color ?? defaultThemedTextColor;

  Color get unSelectedPageButtonTextColor => Colors.grey;
}

/// **TagColors**
/// 태그 색상을 정의합니다.
extension TagColors on ThemeData {
  Color get tagBackgroundColor =>
      brightness == Brightness.light ? Colors.white : const Color(0xFF222222);
}

/// **TabColors**
/// 탭 바의 색상을 정의합니다.
extension TabColors on ThemeData {
  Color? get tabIndicatorColor => Color(0xFF12B8FF);

  Color? get tabLabelColor => Color(0xFF12B8FF);

  Color? get tabUnSelectedLabelColor => Color(0xFFBAB6B6);
}

/// **TextFieldColors**
/// 텍스트 필드 색상을 정의합니다.
extension TextFieldColors on ThemeData {
  Color? get textFieldTextColor => Colors.grey[500];
}

/// **DialogColors**
/// 다이얼로그 관련 색상을 정의합니다.
extension DialogColors on ThemeData {
  Color? get dialogTextColor => Colors.blue;

  Color? get dialogGreyTextColor => Colors.grey;

  Color? get dialogDeleteTextColor => Colors.redAccent;
}

/// **TabPreviewColors**
/// '나만의 탭'의 탭 미리보기 뷰의 색상을 정의합니다.
extension TabPreviewColors on ThemeData {
  Color get tabPreviewBoxBorder =>
      brightness == Brightness.light ? Colors.black38 : Colors.grey.shade800;
}

/// **ChipColors**
/// '나만의 탭'의 Chip의 색상을 정의합니다.
extension ChipColors on ThemeData {
  Color get chipBackground =>
      brightness == Brightness.light ? Colors.white : Colors.grey.shade800;

  Color get chipText =>
      brightness == Brightness.light ? Colors.black87 : Colors.white;

  Color? get chipBorder => brightness == Brightness.light
      ? Colors.grey[300]
      : const Color(0xFF292929);
}

/// **CustomTabListColors**
/// '나만의 탭'의 탭 리스트 색상을 정의합니다.
extension CustomTabListColors on ThemeData {
  Color get dragFeedbackBackground =>
      brightness == Brightness.light ? Colors.white : Colors.black12;
}
