import 'dart:io';

/// Utility class for detecting the test environment.
abstract class TestEnvDetector {
  /// Returns true if the test environment is detected.
  static bool get isTestEnvironment {
    return Platform.environment.containsKey('FLUTTER_TEST');
  }
}
