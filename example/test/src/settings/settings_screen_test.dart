import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart';
import 'package:surf_widget_test_composer_example/src/settings/settings_screen.dart';
import 'package:surf_widget_test_composer_example/src/settings/settings_service.dart';

class MockSettingsService extends Mock implements SettingsService {}

void main() {
  final mockSettingsService = MockSettingsService();

  const widget = SettingsScreen();

  /// Generate golden.
  testWidget<SettingsScreen>(
    desc: 'SettingsScreen',
    widgetBuilder: (context, _) => ProviderScope(
      overrides: [
        settingsServiceProvider.overrideWithValue(mockSettingsService),
      ],
      child: Consumer(
        builder: (context, ref, _) => widget.build(context, ref),
      ),
    ),
    setup: (_, __) {
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
