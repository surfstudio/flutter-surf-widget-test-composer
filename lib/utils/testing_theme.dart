import 'package:flutter/material.dart';

/// Theme for testing.
class TestingTheme {
  /// Theme data.
  final ThemeData data;

  /// Stringified theme name. Used for forming the name of the golden test.
  final String stringified;

  /// Theme type - light or dark.
  final ThemeType type;

  const TestingTheme({
    required this.data,
    required this.stringified,
    required this.type,
  });
}

enum ThemeType {
  dark,
  light;

  ThemeMode get toThemeMode {
    switch (this) {
      case ThemeType.dark:
        return ThemeMode.dark;
      case ThemeType.light:
        return ThemeMode.light;
    }
  }

  const ThemeType();
}
