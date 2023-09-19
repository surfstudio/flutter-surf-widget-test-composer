// ignore_for_file: avoid_implementing_value_types
import 'package:flutter/material.dart';
import 'package:surf_widget_test_composer/utils/test_widget.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

/// Wrapper for the widget test.
///
/// Provides an environment (MaterialApp entry, dependencies, l10n) for the widget test.
///
/// - [childBuilder] - widget to be tested.
/// - [mode] - theme mode.
/// - [themeData] - theme data.
/// - [localizations] - localizations delegates.
/// - [localeOverrides] - supported locales.
/// - [dependencies] - function that allows specifying dependencies for the widget. E.g. Provider, BlocProvider.
class BaseWidgetTestWrapper extends StatelessWidget {
  /// Widget to be tested.
  final WidgetBuilder childBuilder;

  /// Theme mode.
  final ThemeType mode;

  /// Theme data.
  final ThemeData themeData;

  /// Localizations delegates.
  final Iterable<LocalizationsDelegate<dynamic>>? localizations;

  /// Supported locales.
  final Iterable<Locale>? localeOverrides;

  /// Function that allows specifying dependencies for the widget. E.g. Provider, BlocProvider.
  final Widget Function(Widget) dependencies;

  /// @nodoc
  const BaseWidgetTestWrapper({
    required this.childBuilder,
    required this.mode,
    required this.themeData,
    required this.dependencies,
    this.localizations,
    this.localeOverrides,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return materialAppWrapper(
      theme: themeData,
      localizations: localizations,
      localeOverrides: localeOverrides,
    )(
      dependencies(Builder(builder: (context) => childBuilder(context))),
    );
  }
}
