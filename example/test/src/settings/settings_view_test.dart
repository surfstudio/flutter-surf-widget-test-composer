import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart';
import 'package:surf_widget_test_composer_example/src/settings/settings_controller.dart';
import 'package:surf_widget_test_composer_example/src/settings/settings_view.dart';

class MockSettingsController extends Mock implements SettingsController {}

void main() {
  final mockSettingsController = MockSettingsController();

  final widget = SettingsView(
    settingsController: mockSettingsController,
  );

  /// Generate golden.
  testWidget<SettingsView>(
    desc: 'SettingsScreen',
    widgetBuilder: (context, _) => widget.build(context),
    setup: (context, data) {
      when(() => mockSettingsController.themeMode).thenReturn(ThemeMode.dark);
      when(() => mockSettingsController.updateThemeMode(any()))
          .thenAnswer((invocation) => Future.value());
    },

    /// Widget tests
    test: (tester, context) async {
      final button = find.byType(DropdownButton<ThemeMode>);
      expect(button, findsOneWidget);

      final floatingActionButton = find.byIcon(Icons.mode_night);
      expect(floatingActionButton, findsOneWidget);

      verifyNever(() => mockSettingsController.updateThemeMode(any()));
      await tester.tap(floatingActionButton);
      verify(() => mockSettingsController.updateThemeMode(any()));
    },
  );
}
