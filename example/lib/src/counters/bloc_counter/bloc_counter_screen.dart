import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_widget_test_composer_example/src/counters/bloc_counter/bloc_counter_bloc.dart';
import 'package:surf_widget_test_composer_example/src/counters/bloc_counter/bloc_counter_event.dart';
import 'package:surf_widget_test_composer_example/src/localization/localizations_x.dart';

class BlocCounterScreen extends StatelessWidget {
  final BlocCounterBloc bloc;

  const BlocCounterScreen({required this.bloc, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: const _BlocCounterView(),
    );
  }
}

class _BlocCounterView extends StatelessWidget {
  const _BlocCounterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.blocCounterTitle)),
      body: Center(
        child: BlocBuilder<BlocCounterBloc, int>(
          builder: (context, state) => Text(
            '$state',
            style: const TextStyle(fontSize: 36),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.read<BlocCounterBloc>().add(Increment()),
      ),
    );
  }
}
