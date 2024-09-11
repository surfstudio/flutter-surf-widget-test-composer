import 'dart:async';

import 'package:flutter/material.dart';

abstract class ITestStrategy {
  FutureOr<void> test<T>({
    required Widget Function(ThemeData theme, ThemeMode themeMode) widgetBuilder,
    String? screenState,
  });
}
