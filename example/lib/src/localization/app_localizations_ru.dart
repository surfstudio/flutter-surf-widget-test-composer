import 'app_localizations.dart';

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Пример для пакета surf_widget_test_composer.';

  @override
  String get countersTitle => 'Счётчики';

  @override
  String get riverpodCounterTitle => 'Счётчик на базе Riverpod';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSystemTheme => 'Системная тема';

  @override
  String get settingsLightTheme => 'Светлая тема';

  @override
  String get settingsDarkTheme => 'Темная тема';
}
