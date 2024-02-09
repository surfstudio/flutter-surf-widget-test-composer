import 'app_localizations.dart';

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([super.locale = 'ru']);

  @override
  String get appTitle => 'Пример для пакета surf_widget_test_composer.';

  @override
  String get sampleFeatureTitle => 'Элементы для примера';

  @override
  String sampleFeatureSampleItemTitle(int id) {
    return 'Элемент $id';
  }

  @override
  String get sampleFeatureItemDetailsViewTitle => 'Детали элемента';

  @override
  String sampleFeatureItemDetailsViewInfo(String company) {
    return 'Это информация о $company';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSystemTheme => 'Системная тема';

  @override
  String get settingsLightTheme => 'Светлая тема';

  @override
  String get settingsDarkTheme => 'Темная тема';
}
