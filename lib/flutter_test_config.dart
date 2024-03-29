import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart';

typedef WidgetWrapperBuilder = BaseWidgetTestWrapper Function(
  Widget Function(BuildContext),
  ThemeType,
  ThemeData,
  List<LocalizationsDelegate<dynamic>>,
  List<Locale>,
);

/// List of themes used for testing.
@protected
late final List<TestingTheme> themesForTesting;

/// List of localizations used for testing.
@protected
late final List<LocalizationsDelegate<dynamic>> localizationsForTesting;

/// List of locales used for testing.
@protected
late final List<Locale> localesForTesting;

/// Wrapper for the widget test.
@protected
late final WidgetWrapperBuilder widgetWrapper;

/// Background color for the golden file.
@protected
late final Color Function(ThemeData) getBackgroundColor;

/// Entry point for the widget test.
///
/// - [testMain] - function that contains the actual test.
/// - [themes] - list of themes used for testing.
/// - [localizations] - localization delegates used for testing.
/// - [locales] - list of locales used for testing.
/// If not provided, generate goldens only for english.
/// - [wrapper] - wrapper for the widget test.
/// - [backgroundColor] - background color for the golden file.
/// - [devicesForTest] - list of devices used for testing.
/// - [customComparator] - custom comparator for the golden file.
Future<void> testExecutable({
  required FutureOr<void> Function() testMain,
  required List<TestingTheme> themes,
  required WidgetWrapperBuilder wrapper,
  required Color Function(ThemeData) backgroundColor,
  required List<TestDevice> devicesForTest,
  List<LocalizationsDelegate<dynamic>> localizations = const [],
  List<Locale> locales = const [Locale('en')],
  double tolerance = 0.18,
  LocalFileComparator? customComparator,
}) {
  themesForTesting = themes;
  localizationsForTesting = localizations;
  localesForTesting = locales;
  widgetWrapper = wrapper;
  getBackgroundColor = backgroundColor;
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();

      if (goldenFileComparator is LocalFileComparator) {
        goldenFileComparator = customComparator ??
            CustomFileComparator(
              '${(goldenFileComparator as LocalFileComparator).basedir}/goldens',
              tolerance,
            );
      }
    },
    config: GoldenToolkitConfiguration(
      defaultDevices: devicesForTest,
      enableRealShadows: true,
    ),
  );
}

/// Comparator for the golden file.
///
/// Allows specifying the tolerance for the golden file.
class CustomFileComparator extends LocalFileComparator {
  final double tolerance;
  CustomFileComparator(String testFile, this.tolerance)
      : super(Uri.parse(testFile));

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (!result.passed && result.diffPercent >= tolerance) {
      final error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    if (!result.passed) {
      log(
        'A tolerable difference of ${result.diffPercent * 100}% was found when comparing $golden.',
        level: 2000,
      );
    }

    return result.passed || result.diffPercent <= tolerance;
  }
}
