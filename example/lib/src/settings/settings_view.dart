import 'package:flutter/material.dart';
import 'package:surf_widget_test_composer_example/src/localization/localizations_x.dart';
import 'package:surf_widget_test_composer_example/src/settings/settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({
    required this.settingsController,
    super.key,
  });

  static const routeName = '/settings';

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsTitle),
      ),
      floatingActionButton: InkWell(
        onTap: () => settingsController.updateThemeMode(
          Theme.of(context).brightness == Brightness.dark
              ? ThemeMode.light
              : ThemeMode.dark,
        ),
        child: const Icon(Icons.mode_night),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: DropdownButton<ThemeMode>(
          // Read the selected themeMode from the controller
          value: settingsController.themeMode,
          // Call the updateThemeMode method any time the user selects a theme.
          onChanged: settingsController.updateThemeMode,
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
