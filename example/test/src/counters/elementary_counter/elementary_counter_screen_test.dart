import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart';
import 'package:surf_widget_test_composer_example/src/counters/elementary_counter/elementary_counter_screen.dart';
import 'package:surf_widget_test_composer_example/src/counters/elementary_counter/elementary_counter_wm.dart';

class MockElementaryCounterWM extends Mock implements IElementaryCounterWM {}

void main() {
  const widget = ElementaryCounterScreen();
  final wm = MockElementaryCounterWM();

  /// Generate golden.
  testWidget<ElementaryCounterScreen>(
    desc: 'ElementaryCounterScreen',
    widgetBuilder: (context, _) => widget.build(wm),
    setup: (_, __) {
      when(() => wm.title).thenReturn('Elementary Counter');
      when(() => wm.value).thenReturn(StateNotifier<int>(initValue: 0));
      when(() => wm.increment()).thenReturn(null);
    },

    /// Widget tests.
    test: (tester, context) async {
      expect(find.widgetWithText(Center, '0'), findsOneWidget);

      final floatingActionButton = find.byIcon(Icons.add);
      expect(floatingActionButton, findsOneWidget);

      await tester.tap(floatingActionButton);
      verify(wm.increment);
    },
  );
}
