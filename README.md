# Widget Test Composer

## Description

Utility that simplifies widget and golden testing.

## Installation

Add `surf_widget_test_composer` to your `pubspec.yaml`:

```yaml
dependencies:
  surf_widget_test_composer: $currentVersion$
```

## Getting started

You need to create file `test/flutter_test_config.dart`. There you will specify:
- themes of your app you need to test;
- localizations of your app;
- list of devices you want to test on.

E.g. you have two themes: light and dark. You need to test the app on two devices: iPhone 11, Google Pixel 4a and iPhone SE 1. You need to test the app in two languages: English and Russian. You need to test your app on two locales: US and RU. You also have DI scope that you need to wrap your widget with.

Then your file `test/flutter_test_config.dart` will look like this:

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:your_app/assets/colors/app_color_scheme.dart';
import 'package:your_app/assets/themes/app_theme_data.dart';
import 'package:your_app/features/app/di/app_scope.dart';
import 'package:your_app/features/common/widgets/di_scope/di_scope.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart' as helper;

class MockAppScope extends Mock implements IAppScope {}

Future<void> testExecutable(FutureOr<void> Function() testMain) {
  final mockAppScope = MockAppScope();

    /// You can specify your own themes.
    /// Stringified is used for naming screenshots.
  final themes = [
    helper.TestingTheme(
      data: AppThemeData.dark,
      stringified: 'dark',
      type: ThemeType.dark,
    ),
    helper.TestingTheme(
      data: AppThemeData.light,
      stringified: 'light',
      type: ThemeType.light,
    ),
  ];

  /// You can specify your own devices.
  final devices = [
    helper.TestDevice(
      name: 'iphone11',
      size: const Size(414, 896),
      safeArea: const EdgeInsets.only(top: 44, bottom: 34),
    ),
    helper.TestDevice(
      name: 'pixel 4a',
      size: const Size(393, 851),
    ),
    helper.TestDevice(
      name: 'iphone_se_1',
      size: const Size(640 / 2, 1136 / 2),
    ),
  ];

  return helper.testExecutable(
    testMain: testMain,
    themes: themes,
    wrapper: (child, mode, theme, localizations, locales) => helper.BaseWidgetTestWrapper(
      childBuilder: child,
      mode: mode,
      themeData: theme,
      localizations: _localizationsDelegates,
      localeOverrides: _localizations,
      dependencies: (child) => DiScope<IAppScope>(
        factory: () => mockAppScope,
        child: child,
      ),
    ),
    /// You can specify background color of golden test based on current theme.
    backgroundColor: (theme) => theme.colorScheme.background,
    devicesForTest: devices,
  );
}

const _localizations = [
  Locale('en', 'US'),
  Locale('ru', 'RU'),
];

const _localizationsDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

```

## Usage

**IMPORTANT**: Always specify the generic type of the widget you are testing (e.g.,`testWidget<TestableScreen>`), as the golden's name generation is based on the widget class name.

## Example

```dart
class MockTestableScreenWM extends Mock implements ITestableScreenWM {}

void main() {
  final mockData = MockData('test data');
  final widget = TestableScreen(mockData);
  final wm = MockTestableScreenWM();

  testWidget<TestableScreen>(
    desc: 'Test screen',
    widgetBuilder: (_, __) => widget.build(wm),
    setup: (context, mode) {
      when(() => wm.data).thenReturn(EntityValueNotifier(mockData));
      when(() => wm.theme).thenReturn(Theme.of(context));
      when(wm.onSubmitPressed).thenAnswer((_) => Future.value());
      when(wm.onCancelPressed).thenReturn(null);
    },
    test: (tester, theme) async {
        final submitButton = find.widgetWithText(PrimaryButton, CommonStrings.submitButton);
        final cancelButton = find.widgetWithText(SecondaryButton, CommonStrings.cancelButton);
        
        expect(submitButton, findsOneWidget);
        expect(cancelButton, findsOneWidget);
        expect(finder, findsOneWidget);

        await tester.tap(submitButton);
        verify(wm.onSubmitPressed);

        await tester.tap(cancelButton);
        verify(wm.onCancelPressed);
    },
  );

  /// Nothing to test, just want to generate the golden.
  testWidget<TestableScreen>(
    desc: 'Test screen - loading',
    widgetBuilder: (_, __) => widget.build(wm),
    /// Since we are testing a specific widget state, we fill in the [screenState] property.
    screenState: 'loading',
    setup: (context, data) {
      when(() => wm.data).thenReturn(EntityValueNotifier.loading());
      when(() => wm.theme).thenReturn(Theme.of(context));
    }
  );
}
```

## Additional Information

While testing, you can face the following errors:
```sh
00:05 +0: WHEN tasks are not completedTHEN shows `CircularProgressIndicator`                                                                                                                                
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following assertion was thrown while running async test code:
pumpAndSettle timed out
```

This error means that the widget you are testing has an infinite loop. Usually this happens when you use looped animations. In order to fix this you can: 
- define your custom pump function. E.g.:
```dart
/// Nothing to test, just want to generate the golden.
  testWidget<TestableScreen>(
    'Test screen - loading',
    widgetBuilder: (_) => widget.build(wm),
    /// Since we are testing a specific widget state, we fill in the [screenState] property.
    screenState: 'loading',
    /// We define our custom pump function - golden will be generated after 100 milliseconds no matter animation is finished or not.
    customPump: (tester) => tester.pump(const Duration(milliseconds: 100)),
    setup: (context, data) {
      when(() => wm.data).thenReturn(EntityValueNotifier.loading());
      when(() => wm.theme).thenReturn(Theme.of(context));
    }
  );
```
> **NOTE**: This may lead to a mismatch between same goldens - every time you run the test, the golden may be different.

- you also can use `TestEnvDetector.isTestEnvironment` in your widget. E.g.:
  ```dart
  CircularProgressIndicator(
      value: TestEnvDetector.isTestEnvironment ? 0.5 : value,
      color: Colors.blue,
    )
  ```

## Changelog

All notable changes to this project will be documented in [this file](./CHANGELOG.md).

## Issues

To report your issues, submit them directly in the [Issues](https://github.com/surfstudio/flutter-surf-widget-test-composer/issues) section.

## Contribute

If you would like to contribute to the package (e.g. by improving the documentation, fixing a bug or adding a cool new feature), please read our [contribution guide](./CONTRIBUTING.md) first and send us your pull request.

Your PRs are always welcome.

## How to reach us

Please feel free to ask any questions about this package. Join our community chat on Telegram. We speak English and Russian.

[![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/SurfGear)

## License

[Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)