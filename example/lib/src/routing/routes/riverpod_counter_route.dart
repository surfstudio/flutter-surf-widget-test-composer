import 'package:go_router/go_router.dart';
import 'package:surf_widget_test_composer_example/src/counters/riverpod_counter/riverpod_counter_screen.dart';
import 'package:surf_widget_test_composer_example/src/routing/app_router.dart';

final riverpodCounterRoute = GoRoute(
  path: AppRoute.riverpodCounter.path,
  name: AppRoute.riverpodCounter.name,
  builder: (context, state) => const RiverpodCounterScreen(),
);
