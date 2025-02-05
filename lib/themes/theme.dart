import 'package:flutter/material.dart';

// 화이트 모드 테마
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
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

// 다크 모드 테마
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

extension DefaultColors on ThemeData {
  Color get defaultColor =>
      brightness == Brightness.light ? Colors.black : Colors.white;
}

extension TextColors on ThemeData {
  Color get readTextColor =>
      brightness == Brightness.light ? Colors.grey : Colors.grey;
}

extension BorderColors on ThemeData {
  Color get noticeBorderColor => dividerColor;
}

extension BoxBorderColors on ThemeData {
  Color get boxBorderColor =>
      brightness == Brightness.light ? Colors.black26 : Colors.white24;
}

extension SnackBarColors on ThemeData {
  Color get snackBarBackgroundColor =>
      brightness == Brightness.light ? Colors.black87 : const Color(0xFF424242);

  Color get snackBarTextColor =>
      brightness == Brightness.light ? Colors.white : Colors.white70;
}
