import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:surf_widget_test_composer_example/src/counters/counters_screen.dart';
import 'package:surf_widget_test_composer_example/src/routing/routes/riverpod_counter_route.dart';
import 'package:surf_widget_test_composer_example/src/routing/routes/settings_route.dart';

part 'app_router.g.dart';

enum AppRoute {
  counters('/'),
  settings('settings'),
  riverpodCounter('riverpod_counter');

  const AppRoute(this.path);

  final String path;
}

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: AppRoute.counters.path,
    routes: [
      GoRoute(
        path: AppRoute.counters.path,
        name: AppRoute.counters.name,
        builder: (context, state) => const CountersScreen(),
        routes: [
          settingsRoute,
          riverpodCounterRoute,
        ],
      ),
    ],
  );
}
