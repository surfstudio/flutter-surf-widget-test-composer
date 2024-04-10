# Widget Test Composer

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/surfstudio/flutter-open-source/blob/887525c23f4d57a2d96fc2e6a31e15d1e29d1787/assets/logo_white.png">
  <img alt="Shows an illustrated sun in light color mode and a moon with stars in dark color mode." src="https://github.com/surfstudio/flutter-open-source/blob/887525c23f4d57a2d96fc2e6a31e15d1e29d1787/assets/logo_black.png" width ="200">
</picture>

Made by [Surf 🏄‍♂️🏄‍♂️🏄‍♂️](https://surf.dev/)

## Overview

Widget Test Composer is a utility package designed to simplify widget and golden testing processes using [golden_toolkit](https://pub.dev/packages/golden_toolkit) package for Flutter applications. Developed by [Surf :surfer:](https://surf.dev/flutter/) Flutter team :cow2:, it offers comprehensive features to facilitate efficient testing workflows.

## Installation

Add `surf_widget_test_composer` to your `pubspec.yaml`:

```yaml
dependencies:
  surf_widget_test_composer: $currentVersion$
```

## Example

### Getting started

You need to create file `test/flutter_test_config.dart`. There you will specify:

- localizations of your app;
- themes of your app you need to test;
- list of devices you want to test on;
- tolerance for golden tests (the resulting [diffPercent](https://api.flutter.dev/flutter/flutter_test/ComparisonResult/diffPercent.html) must be less than the `tolerance` settings property).

E.g. you have two themes: light and dark. You need to test the app on two devices: iPhone 11, Google Pixel 4a and iPhone SE 1. You need to test the app in two languages: English and Russian. You need to test your app on two locales: US and RU. You also have DI scope that you need to wrap your widget with.

Then your file `test/flutter_test_config.dart` will look like this:

```dart
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart'
    as helper;

/// Localization and locales from auto-generated AppLocalizations.
const _localizations = AppLocalizations.localizationsDelegates;
const _locales = AppLocalizations.supportedLocales;

Future<void> testExecutable(FutureOr<void> Function() testMain) {
  /// You can specify your own themes.
  /// Stringified is used for naming screenshots.
  final themes = [
    helper.TestingTheme(
      data: ThemeData.dark(),
      stringified: 'dark',
      type: helper.ThemeType.dark,
    ),
    helper.TestingTheme(
      data: ThemeData.light(),
      stringified: 'light',
      type: helper.ThemeType.light,
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
    localizations: _localizations,
    locales: _locales,
    wrapper: (child, mode, theme, localizations, locales) =>
        helper.BaseWidgetTestWrapper(
      childBuilder: child,
      mode: mode,
      themeData: theme,
      localizations: localizations,
      localeOverrides: locales,
      // You can specify dependencies here.
      dependencies: (child) => child,
    ),

    /// You can specify background color of golden test based on current theme.
    backgroundColor: (theme) => theme.colorScheme.background,
    devicesForTest: devices,

    /// You can specify tolerance for golden tests.
    tolerance: 0.5,
  );
}
```

According to the config, **12 goldens** will be generated for each test: **2 locales** x **2 themes** x **3 devises**.

> For example [goldens for SampleItemListView](example/test/src/settings/goldens).

### Usage

Now we can prepare tests.

If in addition to golden tests you also need widget tests, then you can make something like this:

```dart
class MockSettingsService extends Mock implements SettingsService {}

void main() {
  final mockSettingsService = MockSettingsService();

  const widget = SettingsScreen();

  /// Generate golden.
  testWidget<SettingsScreen>(
    desc: 'SettingsScreen',
    widgetBuilder: (context, theme) => ProviderScope(
      overrides: [
        settingsServiceProvider.overrideWithValue(mockSettingsService),
      ],
      child: Consumer(
        builder: (context, ref, _) => widget.build(context, ref),
      ),
    ),
    setup: (context, mode) {
      registerFallbackValue(ThemeMode.light);

      when(() => mockSettingsService.themeMode()).thenAnswer(
        (_) => Future.value(ThemeMode.dark),
      );
      when(() => mockSettingsService.updateThemeMode(any()))
          .thenAnswer((_) => Future.value());
    },

    /// Widget tests.
    test: (tester, context) async {
      final button = find.byType(DropdownButton<ThemeMode>);
      expect(button, findsOneWidget);

      final floatingActionButton = find.byIcon(Icons.light_mode);
      expect(floatingActionButton, findsOneWidget);

      verifyNever(() => mockSettingsService.updateThemeMode(any()));
      await tester.tap(floatingActionButton);
      verify(() => mockSettingsService.updateThemeMode(any())).called(1);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mode_night), findsOneWidget);
    },
  );
}
```

If you just need goldens, then the test might look like this:

```dart
void main() {
  const widget = SampleItemListView();

  /// Nothing to test, just want to generate the golden.
  testWidget<SampleItemListView>(
    desc: 'SampleItemListView - result',
    widgetBuilder: (context, _) => widget.build(context),
    // If we need to indicate that we are testing a specific widget/screen state,
    // we can fill in the [screenState] field.
    screenState: 'result',
  );
}
```

> [!WARNING]
> Always specify the generic type of the widget you are testing (e.g.,`testWidget<TestableScreen>`), as the golden's name generation is based on the widget class name.

### Example for Elementary

```dart
class MockElementaryCounterWM extends Mock implements IElementaryCounterWM {}

void main() {
  const int testValue = 5;
  const widget = ElementaryCounterScreen();
  final wm = MockElementaryCounterWM();

  /// Generate golden.
  testWidget<ElementaryCounterScreen>(
    desc: 'ElementaryCounterScreen',
    widgetBuilder: (context, theme) => widget.build(wm),
    setup: (context, mode) {
      when(() => wm.title).thenReturn('Elementary Counter');
      when(() => wm.value).thenReturn(StateNotifier<int>(initValue: testValue));
      when(() => wm.increment()).thenReturn(null);
    },

    /// Widget tests.
    test: (tester, context) async {
      expect(find.widgetWithText(Center, testValue.toString()), findsOneWidget);

      final floatingActionButton = find.byIcon(Icons.add);
      expect(floatingActionButton, findsOneWidget);

      await tester.tap(floatingActionButton);
      verify(wm.increment);
    },
  );
}
```

### Example for Riverpod

```dart
class MockRiverpodCounterScreenController extends AutoDisposeNotifier<int>
    with Mock
    implements RiverpodCounterScreenController {}

void main() {
  const int testValue = 5;
  const widget = RiverpodCounterScreen();
  final mockController = MockRiverpodCounterScreenController();

  final container = ProviderContainer(
    overrides: [
      riverpodCounterScreenControllerProvider
          .overrideWith(() => mockController),
    ],
  );

  /// Generate golden.
  testWidget<RiverpodCounterScreen>(
    desc: 'RiverpodCounterScreen',
    widgetBuilder: (context, theme) => UncontrolledProviderScope(
      container: container,
      child: Consumer(
        builder: (context, ref, _) => widget.build(context, ref),
      ),
    ),

    setup: (context, mode) {
      when(() => mockController.build()).thenReturn(testValue);
      when(() => mockController.increment()).thenReturn(null);
    },

    /// Widget tests.
    test: (tester, context) async {
      expect(find.widgetWithText(Center, testValue.toString()), findsOneWidget);

      final floatingActionButton = find.byIcon(Icons.add);
      expect(floatingActionButton, findsOneWidget);

      await tester.tap(floatingActionButton);
      verify(() => mockController.increment()).called(1);
    },
  );
}
```

### Example for BLoC

```dart
class MockBlocCounterBloc extends Mock implements BlocCounterBloc {}

void main() {
  const int testValue = 5;
  final mockBloc = MockBlocCounterBloc();
  const widget = BlocCounterView();

  /// Generate golden.
  testWidget<BlocCounterView>(
    desc: 'BlocCounterView',
    widgetBuilder: (context, theme) => MultiBlocProvider(
      providers: [
        BlocProvider<BlocCounterBloc>(create: (_) => mockBloc),
      ],
      child: widget,
    ),

    setup: (context, mode) {
      when(() => mockBloc.state).thenReturn(testValue);
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream<int>.fromIterable([testValue]),
      );
      when(() => mockBloc.add(Increment())).thenAnswer((_) => Future.value());
      when(() => mockBloc.close()).thenAnswer((_) => Future.value());
    },

    /// Widget tests.
    test: (tester, context) async {
      expect(find.widgetWithText(Center, testValue.toString()), findsOneWidget);

      final floatingActionButton = find.byIcon(Icons.add);
      expect(floatingActionButton, findsOneWidget);

      await tester.tap(floatingActionButton);
      verify(() => mockBloc.add(Increment())).called(1);
    },
  );
}
```

## Generating goldens

Don't forget to generate goldens before use:

```sh
flutter test --update-goldens --tags=golden
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
