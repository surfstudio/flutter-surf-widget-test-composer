// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart';
import 'package:surf_widget_test_composer_example/src/counters/riverpod_counter/riverpod_counter_screen.dart';
import 'package:surf_widget_test_composer_example/src/counters/riverpod_counter/riverpod_counter_screen_controller.dart';

class MockRiverpodCounterScreenController extends AutoDisposeNotifier<int>
    with Mock
    implements RiverpodCounterScreenController {}

void main() {
  const int testValue = 5;
  const widget = RiverpodCounterScreen();
  final mockController = MockRiverpodCounterScreenController();

  final container = ProviderContainer(
    overrides: [
      riverpodCounterScreenControllerProvider
          .overrideWith(() => mockController),
    ],
  );

  /// Generate golden.
  testWidget<RiverpodCounterScreen>(
    desc: 'RiverpodCounterScreen',
    widgetBuilder: (context, theme) => UncontrolledProviderScope(
      container: container,
      child: Consumer(
        builder: (context, ref, _) => widget.build(context, ref),
      ),
    ),

    setup: (context, mode) {
      when(() => mockController.build()).thenReturn(testValue);
      when(() => mockController.increment()).thenReturn(null);
    },

    /// Widget tests.
    test: (tester, context) async {
      expect(find.widgetWithText(Center, testValue.toString()), findsOneWidget);

      final floatingActionButton = find.byIcon(Icons.add);
      expect(floatingActionButton, findsOneWidget);

      await tester.tap(floatingActionButton);
      verify(() => mockController.increment()).called(1);
    },
  );
}
