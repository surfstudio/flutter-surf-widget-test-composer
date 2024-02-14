import 'app_localizations.dart';

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([super.locale = 'ru']);

  @override
  String get appTitle => 'Пример для пакета surf_widget_test_composer.';

  @override
  String get countersTitle => 'Счётчики';

  @override
  String get riverpodCounterTitle => 'Счётчик на базе Riverpod';

  @override
  String get elementaryCounterTitle => 'Счётчик на базе Elementary';

  @override
  String get blocCounterTitle => 'Счётчик на базе Bloc';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSystemTheme => 'Системная тема';

  @override
  String get settingsLightTheme => 'Светлая тема';

  @override
  String get settingsDarkTheme => 'Темная тема';
}
