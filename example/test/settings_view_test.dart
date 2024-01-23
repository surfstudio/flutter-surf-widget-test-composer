import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart';
import 'package:surf_widget_test_composer_example/src/settings/settings_controller.dart';
import 'package:surf_widget_test_composer_example/src/settings/settings_view.dart';

void main() {
  const widget = SettingsView();

  /// Generate golden.
  testWidget<SettingsView>(
    desc: 'SettingsScreen - goldens',
    widgetBuilder: (context, _) => widget.build(context),
    setup: (context, data) {
      when(() => context.watch<SettingsController>().themeMode)
          .thenReturn(data);
    },
  );

  /// Widget test for DropdownButton.
  testWidget<SettingsView>(
      desc: 'SettingsScreen - DropdownButton test',
      widgetBuilder: (context, _) => widget.build(context),
      setup: (context, data) {
        when(() => context.watch<SettingsController>().themeMode)
            .thenReturn(data);
        when(() => context
                .read<SettingsController>()
                .updateThemeMode(ThemeMode.dark))
            .thenAnswer((invocation) => Future.value());
      },
      test: (tester, _) async {
        /// A way to get context inside test.
        Builder(builder: (context) {
          final updateThemeDropdownButton = find.byType(
            DropdownButton,
          );

          /// Check if there is only one DropdownButton.
          expect(updateThemeDropdownButton, findsOneWidget);

          /// Check if updateThemeMode is called when the DropdownButton item is tapped.
          tester.tap(updateThemeDropdownButton).then(
                (value) => verify(
                  () => context.read<SettingsController>().updateThemeMode,
                ),
              );

          return const Placeholder();
        });
      });
}
