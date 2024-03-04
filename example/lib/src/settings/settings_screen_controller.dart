import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:surf_widget_test_composer_example/src/settings/settings_service.dart';

part 'settings_screen_controller.g.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
@Riverpod(keepAlive: true)
class SettingsScreenController extends _$SettingsScreenController {
  @override
  FutureOr<ThemeMode> build() async => await loadSettings();

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<ThemeMode> loadSettings() async {
    final settingsService = ref.read(settingsServiceProvider);
    return settingsService.themeMode();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == state.value) return;

    // Otherwise, store the new ThemeMode in memory
    state = AsyncData(newThemeMode);

    final settingsService = ref.read(settingsServiceProvider);

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await settingsService.updateThemeMode(newThemeMode);
  }
}
