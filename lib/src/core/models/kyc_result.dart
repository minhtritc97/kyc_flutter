import 'package:kyc_flutter/src/core/enums/kyc_capture_type.dart';
import 'package:kyc_flutter/src/core/enums/kyc_step.dart';
import 'package:kyc_flutter/src/core/models/captured_image.dart';

/// How the KYC flow ended.
enum KycStatus {
  /// All required captures were completed successfully.
  success,

  /// The user closed the screen before finishing.
  cancelled,

  /// The detection timed out before completing (and manual capture was off).
  timeout,
}

/// The result returned by `KYCFlutter.instance.startKyc`.
///
/// Holds the outcome [status] and every [CapturedImage] taken during the flow,
/// each tagged with its [CapturedImage.type] (and [CapturedImage.step] for
/// liveness). Use the convenience getters to pull out a specific capture.
class KycResult {
  /// How the flow ended.
  final KycStatus status;

  /// Every image captured during the flow, in capture order.
  final List<CapturedImage> images;

  const KycResult({required this.status, this.images = const []});

  /// Whether the flow completed successfully.
  bool get isSuccess => status == KycStatus.success;

  /// The image captured in the far framing step, if any.
  CapturedImage? get farImage => _firstOfType(KycCaptureType.far);

  /// The image captured in the near ("move closer") step, if any.
  CapturedImage? get nearImage => _firstOfType(KycCaptureType.near);

  /// The image captured via the manual fallback button, if any.
  CapturedImage? get manualImage => _firstOfType(KycCaptureType.manual);

  /// Images captured during liveness steps, keyed by the step they belong to.
  Map<KYCStep, CapturedImage> get livenessImages => {
    for (final CapturedImage img in images)
      if (img.type == KycCaptureType.liveness && img.step != null)
        img.step!: img,
  };

  CapturedImage? _firstOfType(KycCaptureType type) {
    for (final CapturedImage img in images) {
      if (img.type == type) return img;
    }
    return null;
  }

  @override
  String toString() =>
      'KycResult(status: $status, images: ${images.length})';
}
