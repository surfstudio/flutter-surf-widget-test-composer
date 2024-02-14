import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart';
import 'package:surf_widget_test_composer_example/src/counters/bloc_counter/bloc_counter_screen.dart';

void main() {
  const widget = BlocCounterScreen();

  /// Generate golden.
  testWidget<BlocCounterScreen>(
    desc: 'BlocCounterScreen',
    widgetBuilder: (context, theme) => widget.build(context),

    /// Widget tests.
    test: (tester, context) async {
      expect(find.widgetWithText(Center, '0'), findsOneWidget);

      final floatingActionButton = find.byIcon(Icons.add);
      expect(floatingActionButton, findsOneWidget);

      await tester.tap(floatingActionButton);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(Center, '1'), findsOneWidget);
    },
  );
}
