import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart' as helper;
import 'package:surf_widget_test_composer_example/src/settings/settings_controller.dart';

class MockSettingsController extends Mock implements SettingsController {}

Future<void> testExecutable(FutureOr<void> Function() testMain) {
  final settingsController = MockSettingsController();

  /// You can specify your own themes.
  /// Stringified is used for naming screenshots.
  final themes = [
    TestingTheme(
      data: ThemeData(),
      stringified: 'dark',
      type: ThemeType.dark,
    ),
    TestingTheme(
      data: ThemeData.dark(),
      stringified: 'light',
      type: ThemeType.light,
    ),
  ];

  /// You can specify your own devices.
  final devices = [
    TestDevice(
      name: 'iphone11',
      size: const Size(414, 896),
      safeArea: const EdgeInsets.only(top: 44, bottom: 34),
    ),
    TestDevice(
      name: 'pixel 4a',
      size: const Size(393, 851),
    ),
    TestDevice(
      name: 'iphone_se_1',
      size: const Size(640 / 2, 1136 / 2),
    ),
  ];

  return helper.testExecutable(
    testMain: testMain,
    themes: themes,
    wrapper: (child, mode, theme) => BaseWidgetTestWrapper(
      childBuilder: child,
      mode: mode,
      themeData: theme,
      localizations: _localizationsDelegates,
      localeOverrides: _localizations,
      dependencies: (child) => ChangeNotifierProvider<SettingsController>(
        create: (_) => settingsController,
        child: child,
      ),
    ),

    /// You can specify background color of golden test based on current theme.
    backgroundColor: (theme) => theme.colorScheme.background,
    devicesForTest: devices,
  );
}

const _localizationsDelegates = AppLocalizations.localizationsDelegates;
const _localizations = AppLocalizations.supportedLocales;
