import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_widget_test_composer_example/src/counters/bloc_counter/bloc_counter_event.dart';

class BlocCounterBloc extends Bloc<BlocCounterEvent, int> {
  BlocCounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
  }
}
