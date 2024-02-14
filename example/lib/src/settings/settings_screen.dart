import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surf_widget_test_composer_example/src/localization/localizations_x.dart';
import 'package:surf_widget_test_composer_example/src/settings/settings_screen_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsScreenController is updated and
/// Widgets that listen to the SettingsScreenController are rebuilt.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsScreenControllerProvider);
    final controller = ref.read(settingsScreenControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsTitle),
      ),
      floatingActionButton: InkWell(
        onTap: () => controller.updateThemeMode(
          state.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
        ),
        child: state.value == ThemeMode.dark
            ? const Icon(Icons.light_mode)
            : const Icon(Icons.mode_night),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsScreenController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsScreenController is updated, which rebuilds the MaterialApp.
        child: DropdownButton<ThemeMode>(
          // Read the selected themeMode from the controller
          value: state.value,
          // Call the updateThemeMode method any time the user selects a theme.
          onChanged: controller.updateThemeMode,
          items: [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text(context.l10n.settingsSystemTheme),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text(context.l10n.settingsLightTheme),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text(context.l10n.settingsDarkTheme),
            )
          ],
        ),
      ),
    );
  }
}
