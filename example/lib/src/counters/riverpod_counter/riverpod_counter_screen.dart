import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surf_widget_test_composer_example/src/counters/riverpod_counter/riverpod_counter_screen_controller.dart';
import 'package:surf_widget_test_composer_example/src/localization/localizations_x.dart';

class RiverpodCounterScreen extends ConsumerWidget {
  const RiverpodCounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.read(riverpodCounterScreenControllerProvider.notifier);
    final state = ref.watch(riverpodCounterScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.riverpodCounterTitle)),
      body: Center(
        child: Text(state.toString()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
