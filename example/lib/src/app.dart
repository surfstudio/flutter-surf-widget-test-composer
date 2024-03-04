import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surf_widget_test_composer_example/src/localization/app_localizations.dart';
import 'package:surf_widget_test_composer_example/src/localization/localizations_x.dart';
import 'package:surf_widget_test_composer_example/src/routing/app_router.dart';
import 'package:surf_widget_test_composer_example/src/settings/settings_screen_controller.dart';

/// The Widget that configures your application.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final settingsController = ref.watch(settingsScreenControllerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',
      routerConfig: goRouter,

      // Provide the generated AppLocalizations to the MaterialApp. This
      // allows descendant Widgets to display the correct translations
      // depending on the user's locale.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // Use AppLocalizations to configure the correct application title
      // depending on the user's locale.
      //
      // The appTitle is defined in .arb files found in the localization
      // directory.
      onGenerateTitle: (context) => context.l10n.appTitle,

      // Define a light and dark color theme. Then, read the user's
      // preferred ThemeMode (light, dark, or system default) from the
      // SettingsController to display the correct theme.
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: settingsController.value,
    );
  }
}
