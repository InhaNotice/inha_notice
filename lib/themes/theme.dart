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
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
);

// 다크 모드 테마
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  scaffoldBackgroundColor: const Color(0xFF222222),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF292929),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
  ),

  iconTheme: const IconThemeData(color: Colors.white),
);