import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart';
import 'package:surf_widget_test_composer_example/src/counters/bloc_counter/bloc_counter_bloc.dart';
import 'package:surf_widget_test_composer_example/src/counters/bloc_counter/bloc_counter_event.dart';
import 'package:surf_widget_test_composer_example/src/counters/bloc_counter/bloc_counter_screen.dart';

class MockBlocCounterBloc extends Mock implements BlocCounterBloc {}

void main() {
  const int value = 5;
  final mockBloc = MockBlocCounterBloc();
  const widget = BlocCounterView();

  /// Generate golden.
  testWidget<BlocCounterView>(
    desc: 'BlocCounterView',
    widgetBuilder: (context, theme) => MultiBlocProvider(
      providers: [
        BlocProvider<BlocCounterBloc>(create: (_) => mockBloc),
      ],
      child: widget,
    ),

    setup: (context, mode) {
      when(() => mockBloc.state).thenReturn(value);
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream<int>.fromIterable([value]),
      );
      when(() => mockBloc.add(Increment())).thenAnswer((_) => Future.value());
      when(() => mockBloc.close()).thenAnswer((_) => Future.value());
    },

    /// Widget tests.
    test: (tester, context) async {
      expect(find.widgetWithText(Center, value.toString()), findsOneWidget);

      final floatingActionButton = find.byIcon(Icons.add);
      expect(floatingActionButton, findsOneWidget);

      await tester.tap(floatingActionButton);
      verify(() => mockBloc.add(Increment())).called(1);
    },
  );
}
