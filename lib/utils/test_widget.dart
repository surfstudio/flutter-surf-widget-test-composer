// ignore_for_file: comment_references, depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:meta/meta.dart';
import 'package:surf_widget_test_composer/domain/device.dart';

import '../../flutter_test_config.dart';
import 'testing_theme.dart';

typedef TestFunctionWithTheme = Future Function(WidgetTester, ThemeData);

/// Performs testing of the widget of type [T].
///
/// - [widgetBuilder] - function that returns the widget to be tested.
/// - [desc] - test description.
/// - [setup] - function that sets up configurations before the test. It provides the application theme.
/// - [test] - function containing the actual test. It provides [WidgetTester] and the application theme. No need to call [WidgetTester.pumpWidgetBuilder].
/// - [withGolden] - flag to determine if golden file updates should be performed for this widget.
/// - [deviceMatters] - flag to determine if golden files should be generated for different devices.
/// - [screenState] - string that allows specifying the screen state (e.g., loading, error).
/// - [skip] - Allows skipping the test.
/// - [onlyOneTheme] - Uses only one of the themes for the test (the first one from the list).
/// - [customPump] - Allows customizing the pump function.
/// - [devices] - Allows specifying the devices for which the golden files should be generated.
/// - [autoHeight] - Allows specifying if the height of the golden file should be automatically adjusted.
/// - [deviceSetup] - Allows specifying the setup function for each device.
@isTest
void testWidget<T extends Widget>({
  required Widget Function(ThemeType) widgetBuilder,
  String? desc,
  TestFunctionWithTheme? test,
  void Function(BuildContext, ThemeMode)? setup,
  bool withGolden = true,
  bool deviceMatters = true,
  bool autoHeight = false,
  bool? skip,
  String? screenState,
  Future<void> Function(WidgetTester)? customPump,
  Future<void> Function(TestDevice, WidgetTester)? deviceSetup,
  List<Device>? devices,
  bool onlyOneTheme = false,
}) =>
    testGoldens(
      desc ?? 'Golden for $T',
      skip: skip,
      (tester) async {
        await loadAppFonts();

        final List<TestingTheme> themesForTest;

        // If the theme is not important for the test, the first one from the list will be used.
        themesForTest = onlyOneTheme ? [themesForTesting.first] : themesForTesting;

        /// Iterate over each theme.
        for (final theme in themesForTest) {
          /// Call setup if available.

          // final widget = widgetBuilder(theme.data);

          await tester.pumpWidgetBuilder(
            const SizedBox.shrink(),
            wrapper: (_) => widgetWrapper(
              (context) {
                setup?.call(context, theme.type.toThemeMode);
                return ColoredBox(
                  color: getBackgroundColor(theme.data),
                  child: widgetBuilder(theme.type),
                );
              },
              theme.type,
              theme.data,
            ),
          );

          /// Call the test if available.
          await test?.call(tester, theme.data);

          if (withGolden) {
            /// Generate golden files.
            await multiScreenGolden(
              tester,
              _getGoldenName<T>(
                theme,
                screenState,
                includeThemeName: !onlyOneTheme,
              ),
              devices: deviceMatters ? null : [Device.phone],
              autoHeight: autoHeight,
            );

            await tester.pumpWidget(Container());
          }
        }
      },
    );

/// Forms the name of the golden file from:
/// - widget type [T] (converts camelCase to snake_case - e.g., `LoadStoreScreen` -> `load_store_screen`)
///   - if the widget has generic parameter, it will also be converted to snake_case
/// - theme prefix (`dark_theme`/`light_theme`)
/// - screen state [state], if provided (e.g., `loading`, 'loading state' -> 'loading_state')
/// - [includeThemeName] - whether to include the theme name in the file name
///
/// Example value: `dark_theme.loading.load_store_screen`
String _getGoldenName<T>(
  TestingTheme theme,
  String? state, {
  bool includeThemeName = true,
}) {
  final exp = RegExp('(?<=[a-z])[A-Z]');
  final name = T
      .toString()
      .replaceAllMapped(exp, (m) => '_${m.group(0)}')
      .toLowerCase()
      .replaceAll('<', '_')
      .replaceAll('>', '');

  final formattedState = state?.trim().replaceAll(' ', '_');

  return '${includeThemeName ? theme.stringified : 'no_theme'}${formattedState == null ? '.' : '.$formattedState.'}$name';
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
