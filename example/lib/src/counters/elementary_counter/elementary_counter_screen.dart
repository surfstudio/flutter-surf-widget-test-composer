import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:surf_widget_test_composer_example/src/counters/elementary_counter/elementary_counter_wm.dart';

class ElementaryCounterScreen extends ElementaryWidget<IElementaryCounterWM> {
  const ElementaryCounterScreen({
    Key? key,
    WidgetModelFactory wmFactory = testPageWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IElementaryCounterWM wm) {
    return Scaffold(
      appBar: AppBar(title: Text(wm.title)),
      body: Center(
        child: StateNotifierBuilder<int>(
          listenableState: wm.value,
          builder: (_, value) {
            return Text(value.toString());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: wm.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
