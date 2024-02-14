import 'package:go_router/go_router.dart';
import 'package:surf_widget_test_composer_example/src/counters/elementary_counter/elementary_counter_screen.dart';
import 'package:surf_widget_test_composer_example/src/routing/app_router.dart';

final elementaryCounterRoute = GoRoute(
  path: AppRoute.elementaryCounter.path,
  name: AppRoute.elementaryCounter.name,
  builder: (context, state) => const ElementaryCounterScreen(),
);
