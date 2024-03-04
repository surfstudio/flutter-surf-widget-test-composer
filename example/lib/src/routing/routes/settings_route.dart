import 'package:go_router/go_router.dart';
import 'package:surf_widget_test_composer_example/src/routing/app_router.dart';
import 'package:surf_widget_test_composer_example/src/settings/settings_screen.dart';

final settingsRoute = GoRoute(
  path: AppRoute.settings.path,
  name: AppRoute.settings.name,
  builder: (context, state) => const SettingsScreen(),
);
