import 'package:flutter/material.dart';

import 'test_widget.dart';

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
