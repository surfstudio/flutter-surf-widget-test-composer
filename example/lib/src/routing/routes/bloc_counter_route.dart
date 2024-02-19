import 'package:go_router/go_router.dart';
import 'package:surf_widget_test_composer_example/src/counters/bloc_counter/bloc_counter_bloc.dart';
import 'package:surf_widget_test_composer_example/src/counters/bloc_counter/bloc_counter_screen.dart';
import 'package:surf_widget_test_composer_example/src/routing/app_router.dart';

final blocCounterRoute = GoRoute(
  path: AppRoute.blocCounter.path,
  name: AppRoute.blocCounter.name,
  builder: (context, state) => BlocCounterScreen(bloc: BlocCounterBloc()),
);
