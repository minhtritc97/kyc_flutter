import 'package:kyc_flutter/src/_internal.dart';

class Utils {
  /// Generates a unique identifier, used for naming captured image files.
  static String generate() {
    return const Uuid().v4();
  }
}
