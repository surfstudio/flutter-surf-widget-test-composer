import 'package:surf_widget_test_composer/surf_widget_test_composer.dart';
import 'package:surf_widget_test_composer_example/src/counters/counters_screen.dart';

void main() {
  const widget = CountersScreen();

  /// Nothing to test, just want to generate the golden.
  testWidget<CountersScreen>(
    desc: 'Counters list - result',
    widgetBuilder: (context, _) => widget.build(context),
    // If we need to indicate that we are testing a specific widget/screen state,
    // we can fill in the [screenState] field.
    screenState: 'result',
  );
}
