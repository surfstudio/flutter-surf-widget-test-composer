import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([super.locale = 'en']);

  @override
  String get appTitle => 'Example for the surf_widget_test_composer package.';

  @override
  String get sampleFeatureTitle => 'Sample Items';

  @override
  String sampleFeatureSampleItemTitle(int id) {
    return 'Item $id';
  }

  @override
  String get sampleFeatureItemDetailsViewTitle => 'Item Details';

  @override
  String sampleFeatureItemDetailsViewInfo(String company) {
    return 'This info about $company';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSystemTheme => 'System Theme';

  @override
  String get settingsLightTheme => 'Light Theme';

  @override
  String get settingsDarkTheme => 'Dark Theme';
}
