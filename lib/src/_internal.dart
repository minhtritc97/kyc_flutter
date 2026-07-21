/// Internal umbrella barrel shared by the package's `src` implementation files.
///
/// This is NOT part of the public API — it re-exports the third-party
/// dependencies and every internal declaration the implementation relies on so
/// each `src` file only needs this single import. Consumers should import
/// `package:kyc_flutter/kyc_flutter.dart` instead.
library;

// Dart SDK
export 'dart:convert';
export 'dart:io';
export 'dart:math';

// Third-party dependencies
export 'package:camerawesome/camerawesome_plugin.dart';
export 'package:camerawesome/pigeon.dart';
export 'package:flutter/material.dart';
export 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
export 'package:path_provider/path_provider.dart';
export 'package:uuid/uuid.dart';

// Controllers
export 'controllers/capture_controller.dart';
export 'controllers/detection_controller.dart';
export 'controllers/stable_face_controller.dart';

// Enums
export 'core/enums/face_phase.dart';
export 'core/enums/kyc_capture_type.dart';
export 'core/enums/kyc_step.dart';

// Extensions
export 'core/extensions/ml_kit_extension.dart';

// Helpers
export 'core/helpers/face_overlay_layout.dart';
export 'core/helpers/utils.dart';

// Models
export 'core/models/captured_image.dart';
export 'core/models/detection_config.dart';
export 'core/models/face_validation_result.dart';
export 'core/models/kyc_result.dart';
export 'core/models/kyc_strings.dart';

// Services
export 'core/services/face_detection_service.dart';

// Screens
export 'screens/components/banking_face_overlay.dart';
export 'screens/kyc_screen.dart';
