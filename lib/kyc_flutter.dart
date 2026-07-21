import 'package:kyc_flutter/src/_internal.dart';

// Public API — only the types a consumer needs to configure and run detection.
export 'src/core/enums/kyc_capture_type.dart';
export 'src/core/enums/kyc_step.dart';
export 'src/core/models/captured_image.dart';
export 'src/core/models/detection_config.dart';
export 'src/core/models/kyc_result.dart';
export 'src/core/models/kyc_strings.dart';

/// Entry point of the package.
///
/// Call [startKyc] with a [DetectionConfig] to open the KYC screen and run the
/// banking-style face authentication flow. It returns a [KycResult] describing
/// the outcome and every captured image when the screen closes.
class KYCFlutter {
  KYCFlutter._privateConstructor();

  static final KYCFlutter instance = KYCFlutter._privateConstructor();

  /// Opens the KYC screen and runs the face detection / liveness flow.
  ///
  /// * [context] is used to push the KYC screen route.
  /// * [config] holds the flow configuration (steps, strings, thresholds,
  ///   durations).
  ///
  /// Returns a [KycResult] with the outcome [KycStatus] and the captured
  /// images. If the user backs out without finishing, the result status is
  /// [KycStatus.cancelled].
  Future<KycResult> startKyc(
    BuildContext context, {
    required DetectionConfig config,
  }) async {
    final KycResult? result = await Navigator.of(context).push<KycResult>(
      MaterialPageRoute(builder: (context) => KYCScreen(config: config)),
    );
    return result ?? const KycResult(status: KycStatus.cancelled);
  }
}
