/// What a [CapturedImage] represents within the KYC flow.
enum KycCaptureType {
  /// Captured while the face was framed at a comfortable (far) distance.
  far,

  /// Captured after the user moved the phone closer.
  near,

  /// Captured while completing a liveness challenge (blink/smile/turn).
  liveness,

  /// Captured via the manual fallback button (after the timeout).
  manual,
}
