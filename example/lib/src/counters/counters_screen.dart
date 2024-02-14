import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_widget_test_composer_example/src/counters/counter.dart';
import 'package:surf_widget_test_composer_example/src/localization/localizations_x.dart';
import 'package:surf_widget_test_composer_example/src/routing/app_router.dart';

/// Displays a list of SampleItems.
class CountersScreen extends StatelessWidget {
  const CountersScreen({
    super.key,
    this.counters = const [
      Counter(
        icon: Icons.waves,
        route: AppRoute.riverpodCounter,
      ),
      Counter(
        icon: Icons.grid_view,
        route: AppRoute.elementaryCounter,
      ),
    ],
  });

  final List<Counter> counters;

  @override
  Widget build(BuildContext context) {
    String getTitle(BuildContext context, AppRoute route) => switch (route) {
          AppRoute.riverpodCounter => context.l10n.riverpodCounterTitle,
          AppRoute.elementaryCounter => context.l10n.elementaryCounterTitle,
          AppRoute.settings || AppRoute.counters => 'Unexpected route',
        };

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.countersTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.goNamed(AppRoute.settings.name),
          ),
        ],
      ),
      body: ListView.builder(
        restorationId: 'countersScreen',
        itemCount: counters.length,
        itemBuilder: (context, index) {
          final counter = counters[index];

          return ListTile(
            title: Text(getTitle(context, counter.route)),
            leading: Icon(counter.icon),
            onTap: () => context.goNamed(counter.route.name),
          );
        },
      ),
    );
  }
}
