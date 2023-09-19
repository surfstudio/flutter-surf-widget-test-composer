import 'package:golden_toolkit/golden_toolkit.dart';

class TestDevice extends Device {
  TestDevice({
    required super.size,
    required super.name,
    super.devicePixelRatio,
    super.safeArea,
  });
}
