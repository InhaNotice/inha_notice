import 'package:flutter/material.dart';

/// Enum representing supported language types in the app
enum AppLanguageType {
  korean('한국어', 'ko'),
  english('English', 'en');

  final String text;
  final String value;

  const AppLanguageType(this.text, this.value);

  /// Get AppLanguageType from language code value
  static AppLanguageType fromValue(String value) {
    return AppLanguageType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AppLanguageType.korean,
    );
  }

  /// Convert to Flutter Locale
  Locale toLocale() => Locale(value);
}
