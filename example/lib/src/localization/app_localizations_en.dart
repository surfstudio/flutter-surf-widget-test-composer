import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([super.locale = 'en']);

  @override
  String get appTitle => 'Example for the surf_widget_test_composer package.';

  @override
  String get countersTitle => 'Counters';

  @override
  String get riverpodCounterTitle => 'Counter based on Riverpod';

  @override
  String get elementaryCounterTitle => 'Counter based on Elementary';

  @override
  String get blocCounterTitle => 'Counter based on Bloc';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSystemTheme => 'System Theme';

  @override
  String get settingsLightTheme => 'Light Theme';

  @override
  String get settingsDarkTheme => 'Dark Theme';
}
