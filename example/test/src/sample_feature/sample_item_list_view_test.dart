import 'package:surf_widget_test_composer/surf_widget_test_composer.dart';
import 'package:surf_widget_test_composer_example/src/sample_feature/sample_item_list_view.dart';

void main() {
  const widget = SampleItemListView();

  /// Nothing to test, just want to generate the golden.
  testWidget<SampleItemListView>(
    desc: 'SampleItemListView - result',
    widgetBuilder: (context, _) => widget.build(context),
    // If we need to indicate that we are testing a specific widget/screen state,
    // we can fill in the [screenState] field.
    screenState: 'result',
  );
}
