import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_widget_test_composer_example/src/counters/bloc_counter/bloc_counter_bloc.dart';
import 'package:surf_widget_test_composer_example/src/counters/bloc_counter/bloc_counter_event.dart';
import 'package:surf_widget_test_composer_example/src/localization/localizations_x.dart';

class BlocCounterScreen extends StatelessWidget {
  const BlocCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlocCounterBloc(),
      child: const _CounterView(),
    );
  }
}

class _CounterView extends StatelessWidget {
  const _CounterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.blocCounterTitle)),
      body: Center(
        child: BlocBuilder<BlocCounterBloc, int>(
          builder: (context, state) => Text('$state'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('blocCounterScreen_increment_floatingActionButton'),
        child: const Icon(Icons.add),
        onPressed: () => context.read<BlocCounterBloc>().add(Increment()),
      ),
    );
  }
}
