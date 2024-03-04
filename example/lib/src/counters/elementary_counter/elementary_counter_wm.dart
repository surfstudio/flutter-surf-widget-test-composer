import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:surf_widget_test_composer_example/src/counters/elementary_counter/elementary_counter_model.dart';
import 'package:surf_widget_test_composer_example/src/counters/elementary_counter/elementary_counter_screen.dart';
import 'package:surf_widget_test_composer_example/src/localization/localizations_x.dart';

/// Builder for [ElementaryCounterWM]
ElementaryCounterWM testPageWidgetModelFactory(BuildContext context) {
  return ElementaryCounterWM(ElementaryCounterModel());
}

/// WidgetModel for [ElementaryCounterScreen]
class ElementaryCounterWM
    extends WidgetModel<ElementaryCounterScreen, ElementaryCounterModel>
    implements IElementaryCounterWM {
  @override
  ListenableState<int> get value => _valueState;

  @override
  String get title => context.l10n.elementaryCounterTitle;

  late StateNotifier<int> _valueState;

  ElementaryCounterWM(super.model);

  @override
  void increment() {
    final newValue = model.increment();
    _valueState.accept(newValue);
  }

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    _valueState = StateNotifier<int>(initValue: model.value);
  }

  @override
  void dispose() {
    _valueState.dispose();

    super.dispose();
  }
}

abstract interface class IElementaryCounterWM implements IWidgetModel {
  ListenableState<int> get value;

  String get title;

  void increment();
}
