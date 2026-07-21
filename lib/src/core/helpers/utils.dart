import 'dart:math';

class Utils {
  static final Random _random = Random();

  /// Generates a unique-enough identifier for naming captured image files,
  /// without pulling in any third-party dependency.
  static String generate() {
    final int timestamp = DateTime.now().microsecondsSinceEpoch;
    final int random = _random.nextInt(0xFFFFFFFF);
    return '${timestamp}_$random';
  }
}
