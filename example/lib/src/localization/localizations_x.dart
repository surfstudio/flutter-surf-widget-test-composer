import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Extension for simplified work with localized strings.
extension LocalizationsX on BuildContext {
  /// Getter for strings.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
