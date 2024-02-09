import 'package:flutter/material.dart';
import 'package:surf_widget_test_composer_example/src/localization/app_localizations.dart';

/// Extension for simplified work with localized strings.
extension LocalizationsX on BuildContext {
  /// Getter for strings.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
