import 'package:kyc_flutter/src/_internal.dart';

class DetectionConfig {
  /// Optional liveness challenges to run after the mandatory "look straight"
  /// far and near captures, in the given order. Leave empty for face framing
  /// only (no extra challenges).
  final List<KYCStep> steps;

  /// Timeout (in seconds) for the whole detection flow. When it elapses, the
  /// flow either shows a manual capture button ([allowAfterMaxSec] is `true`)
  /// or ends with [KycStatus.timeout].
  ///
  /// `null` (the default) means **no time limit** — the flow runs until the
  /// user completes or cancels it.
  final int? maxSecToDetect;

  /// A boolean value that deinfes whether to allow the user to click the selfie even if the face is not detected.
  final bool allowAfterMaxSec;

  /// Icon color of the button that will come after the [maxSecToDetect] is completed.
  final Color? captureButtonColor;

  /// All user-facing strings shown during the flow. Defaults to English; pass a
  /// customized [KycStrings] to localize or reword the on-screen guidance.
  final KycStrings strings;

  /// Minimum face-distance metric required to capture the *far* face, expressed
  /// as a fraction (0..1) of the analysis image's shortest side (the face
  /// bounding-box width). Below this the face is considered too far/small.
  /// Default *0.28*.
  final double farThreshold;

  /// Minimum face-distance metric required to capture the *near* face (the
  /// "move closer" step), as a fraction (0..1) of the image's shortest side.
  /// Default *0.50*.
  final double nearThreshold;

  /// How long a valid far face must be held steady before it is captured.
  /// Default *2.5s*.
  final Duration farStableDuration;

  /// How long a valid near face must be held steady before it is captured.
  /// Default *2s*.
  final Duration nearStableDuration;

  /// Minimum ML Kit `smilingProbability` (0..1) required to pass the
  /// [KYCStep.smile] step. Higher == the user must smile more clearly.
  /// Default *0.5*.
  final double smileThreshold;

  const DetectionConfig({
    this.steps = const [],
    this.maxSecToDetect,
    this.allowAfterMaxSec = false,
    this.captureButtonColor,
    this.strings = const KycStrings(),
    this.farThreshold = 0.28,
    this.nearThreshold = 0.50,
    this.farStableDuration = const Duration(milliseconds: 2500),
    this.nearStableDuration = const Duration(milliseconds: 2000),
    this.smileThreshold = 0.5,
  });
}
