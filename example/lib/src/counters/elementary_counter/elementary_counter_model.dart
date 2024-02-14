import 'package:elementary/elementary.dart';

/// Model example.
class ElementaryCounterModel extends ElementaryModel {
  int get value => _value;
  var _value = 0;

  ElementaryCounterModel();

  int increment() => ++_value;
}
