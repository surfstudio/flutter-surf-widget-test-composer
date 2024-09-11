import 'package:flutter/material.dart';

class FigmaConfig {
  final Size size;
  final ThemeMode themeMode;
  final ThemeData theme;
  final EdgeInsets cropOffset;
  final String link;
  final String? layoutName;

  FigmaConfig({
    required this.size,
    required this.theme,
    required this.themeMode,
    required this.cropOffset,
    required this.link,
    this.layoutName,
  });
}
