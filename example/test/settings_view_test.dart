import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:surf_widget_test_composer/surf_widget_test_composer.dart';
import 'package:surf_widget_test_composer_example/src/settings/settings_controller.dart';
import 'package:surf_widget_test_composer_example/src/settings/settings_view.dart';

void main() {
  const widget = SettingsView();

  /// Generate golden.
  testWidget<SettingsView>(
    desc: 'SettingsScreen',
    widgetBuilder: (context, _) => widget.build(context),
    setup: (context, data) {
      when(() => context.watch<SettingsController>().themeMode)
          .thenReturn(data);
    },
  );
}
