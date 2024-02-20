import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_widget_test_composer_example/src/counters/bloc_counter/bloc_counter_bloc.dart';
import 'package:surf_widget_test_composer_example/src/counters/bloc_counter/bloc_counter_event.dart';
import 'package:surf_widget_test_composer_example/src/localization/localizations_x.dart';

class BlocCounterScreen extends StatefulWidget {
  const BlocCounterScreen({super.key});

  @override
  State<BlocCounterScreen> createState() => _BlocCounterScreenState();
}

class _BlocCounterScreenState extends State<BlocCounterScreen> {
  final bloc = BlocCounterBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: const BlocCounterView(),
    );
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}

class BlocCounterView extends StatelessWidget {
  const BlocCounterView({super.key});

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
