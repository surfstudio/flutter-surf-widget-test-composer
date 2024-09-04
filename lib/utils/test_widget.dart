// ignore_for_file: comment_references, depend_on_referenced_packages

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:meta/meta.dart';
import 'package:surf_widget_test_composer/domain/device.dart';
import 'package:surf_widget_test_composer/domain/figma_config.dart';
import 'package:surf_widget_test_composer/flutter_test_config.dart';
import 'package:surf_widget_test_composer/service/figma_api.dart';
import 'package:surf_widget_test_composer/utils/testing_theme.dart';
import 'package:collection/collection.dart';

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
/// - [onlyOneLocale] - Uses only one of the locales for the test (the first one from the list).
/// - [customPump] - Allows customizing the pump function.
/// - [devices] - Allows specifying the devices for which the golden files should be generated.
/// - [autoHeight] - Allows specifying if the height of the golden file should be automatically adjusted.
/// - [deviceSetup] - Allows specifying the setup function for each device.
@isTest
void testWidget<T extends Widget>({
  required Widget Function(BuildContext, ThemeType) widgetBuilder,
  String? desc,
  TestFunctionWithTheme? test,
  void Function(BuildContext, ThemeMode)? setup,
  bool withGolden = true,
  bool deviceMatters = true,
  bool autoHeight = false,
  bool? skip,
  String? screenState,
  List<FigmaConfig>? themesToFigmaLinks,
  Future<void> Function(WidgetTester)? customPump,
  Future<void> Function(TestDevice, WidgetTester)? deviceSetup,
  List<Device>? devices,
  bool onlyOneTheme = false,
  bool onlyOneLocale = false,
}) async {
  final localesForTest =
      onlyOneLocale ? [localesForTesting.firstOrNull].whereNotNull() : localesForTesting;

  testGoldens(
    desc ?? 'Golden for $T',
    skip: skip,
    (tester) async {
      await loadAppFonts();

      // If the theme is not important for the test, the first one from the list will be used.
      final themesForTest =
          onlyOneTheme ? [themesForTesting.firstOrNull].whereNotNull() : themesForTesting;

      assert(
        themesForTest.isNotEmpty,
        'At least one theme should be provided for the test.',
      );

      assert(
        localesForTest.isNotEmpty,
        'At least one locale should be provided for the test.',
      );

      /// Iterate over each theme.
      for (final theme in themesForTest) {
        /// Iterate over each locale.
        for (final locale in localesForTest) {
          /// Call setup if available.
          await tester.pumpWidgetBuilder(
            const SizedBox.shrink(),
            wrapper: (_) => widgetWrapper(
              (context) {
                setup?.call(context, theme.type.toThemeMode);
                return ColoredBox(
                  color: getBackgroundColor(theme.data),
                  child: widgetBuilder(context, theme.type),
                );
              },
              theme.type,
              theme.data,
              localizationsForTesting,
              [locale],
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
                locale: localesForTest.length == 1 ? null : locale,
                includeThemeName: !onlyOneTheme,
              ),
              devices: deviceMatters ? null : [Device.phone],
              autoHeight: autoHeight,
            );

            await tester.pumpWidget(Container());
          }
        }
      }
    },
  );

  final imageBytes = <FigmaConfig, Uint8List?>{};
  final figmaToken = tokenFromFigma;

  testWidgets(
    'Retrieve figma images of $T',
    (widgetTester) async {
      await Future.forEach(
        themesToFigmaLinks ?? [],
        (config) async {
          final figmaLink = config.link;
          if (figmaLink != null && figmaToken != null) {
            await widgetTester.runAsync(
              () async {
                await HttpOverrides.runZoned(
                  () async {
                    final image = await FigmaRestApi.downloadFrameImage(
                      figmatToken: figmaToken,
                      figmaframeUrl: figmaLink,
                      imageScale: 1,
                    );

                    if (image != null) {
                      imageBytes[config] = image;
                    }
                  },
                  createHttpClient: (SecurityContext? context) {
                    return _MyHttpOverrides().createHttpClient(context);
                  },
                );
              },
            );
          }
        },
      );
    },
  );

  for (final FigmaConfig config in themesToFigmaLinks ?? []) {
    testGoldens('Figma and Implementation Comparison of $T', (tester) async {
      final theme = themesForTesting.first;
      final image = imageBytes[config];
      if (image != null) {
        final builder = GoldenBuilder.grid(
          columns: 2,
          widthToHeightRatio: 0.2,
        );

        builder.addScenario(
          'Figma',
          Transform.translate(
            offset: Offset(-config.cropOffset.left, -config.cropOffset.top),
            child: _CroppedImageWidget(image, config.cropOffset),
          ),
        );

        final locale = localesForTest.firstOrNull ?? (throw Exception('Locale is not provided.'));

        builder.addScenario(
          'Real',
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: config.size.width - config.cropOffset.left - config.cropOffset.right,
              maxHeight: config.size.height - config.cropOffset.top - config.cropOffset.bottom,
            ),
            child: SizedBox(
              width: config.size.width - config.cropOffset.left - config.cropOffset.right,
              height: config.size.height - config.cropOffset.top - config.cropOffset.bottom,
              child: widgetWrapper(
                (context) {
                  setup?.call(context, theme.type.toThemeMode);
                  return ColoredBox(
                    color: getBackgroundColor(theme.data),
                    child: widgetBuilder(context, theme.type),
                  );
                },
                theme.type,
                theme.data,
                localizationsForTesting,
                [locale],
              ),
            ),
          ),
        );

        await tester.pumpWidgetBuilder(
          builder.build(),
          surfaceSize: Size(
            (config.size.width - config.cropOffset.left - config.cropOffset.right) * 2 + 50,
            (config.size.height - config.cropOffset.bottom - config.cropOffset.top) + 100,
          ),
          wrapper: materialAppWrapper(),
        );

        await screenMatchesGolden(
          tester,
          _getGoldenName<T>(
            theme,
            screenState,
            includeThemeName: !onlyOneTheme,
            fromFigma: true,
          ),
        );
      }
    });
  }
}

/// Forms the name of the golden file from:
/// - widget type [T] (converts camelCase to snake_case - e.g., `LoadStoreScreen` -> `load_store_screen`)
/// - if the widget has generic parameter, it will also be converted to snake_case
/// - theme prefix (`dark_theme`/`light_theme`)
/// - optional locale ('en', 'ru', etc.)
/// - screen state [state], if provided (e.g., `loading`, 'loading state' -> 'loading_state')
/// - [includeThemeName] - whether to include the theme name in the file name
///
/// Example value: `dark.en.loading.load_store_screen`
String _getGoldenName<T>(
  TestingTheme theme,
  String? state, {
  Locale? locale,
  bool includeThemeName = true,
  bool fromFigma = false,
}) {
  final exp = RegExp('(?<=[a-z])[A-Z]');
  final name = T
      .toString()
      .replaceAllMapped(exp, (m) => '_${m.group(0)}')
      .toLowerCase()
      .replaceAll('<', '_')
      .replaceAll('>', '');

  final formattedState = state?.trim().replaceAll(' ', '_');

  final result = '$name.'
      '${formattedState == null ? '' : '$formattedState.'}'
      '${locale == null ? '' : '${locale.languageCode}.'}'
      '${includeThemeName ? theme.stringified : 'no_theme'}';

  return fromFigma ? 'figma.$result' : result;
}

class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class _CustomImageClipper extends CustomClipper<Rect> {
  final EdgeInsets cropOffset;

  _CustomImageClipper(this.cropOffset);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      cropOffset.left,
      cropOffset.top,
      size.width - cropOffset.right,
      size.height - cropOffset.bottom,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}

class _CroppedImageWidget extends StatelessWidget {
  final Uint8List imageBytes;
  final EdgeInsets cropOffset;

  const _CroppedImageWidget(this.imageBytes, this.cropOffset);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper: _CustomImageClipper(cropOffset),
      child: Image.memory(imageBytes),
    );
  }
}
