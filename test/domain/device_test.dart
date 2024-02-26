import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surf_widget_test_composer/domain/device.dart';

void main() {
  group('TestDevice', () {
    test('should create TestDevice instance', () {
      final device = TestDevice(
        size: const Size(1080, 1920),
        name: 'Test Device',
        devicePixelRatio: 2.0,
        safeArea: const EdgeInsets.all(10.0),
      );

      expect(device, isNotNull);
      expect(device.name, equals('Test Device'));
      expect(device.size, equals(const Size(1080, 1920)));
      expect(device.devicePixelRatio, equals(2.0));
      expect(device.safeArea, equals(const EdgeInsets.all(10.0)));
    });
  });
}
