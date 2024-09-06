import 'package:flutter/rendering.dart';
import 'package:surf_widget_test_composer/utils/testing_theme.dart';

class FigmaConfig {
  final Size size;
  final TestingTheme theme;
  final EdgeInsets cropOffset;
  final String link;
  final String? layoutName;

  FigmaConfig({
    required this.size,
    required this.theme,
    required this.cropOffset,
    required this.link,
    this.layoutName,
  });
}
