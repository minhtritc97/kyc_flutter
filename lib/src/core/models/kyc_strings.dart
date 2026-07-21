/// All user-facing strings shown during the KYC flow.
///
/// Every field has an English default so the package works out of the box.
/// Pass a customized instance via [DetectionConfig.strings] to localize or
/// reword the on-screen guidance without touching the package.
class KycStrings {
  /// Shown while the camera is warming up.
  final String initializing;

  /// Prompt to bring the face into the oval (far positioning / no face).
  final String positionFace;

  /// Prompt to move the face closer (near phase).
  final String moveCloser;

  /// Subtitle hint reinforcing the "move closer" prompt.
  final String moveCloserHint;

  /// Subtitle shown while a valid face is being held steady.
  final String holdStill;

  /// Shown once the whole flow is finished.
  final String completed;

  /// Shown when more than one face is visible.
  final String multipleFaces;

  /// Prompt to look straight at the camera.
  final String lookStraight;

  /// Prompt when the face is too far / too small (far phase).
  final String tooFar;

  /// Prompt when the face is too close / too large.
  final String tooClose;

  /// Liveness prompt: blink.
  final String blink;

  /// Liveness prompt: smile.
  final String smile;

  /// Liveness prompt: turn head left.
  final String turnLeft;

  /// Liveness prompt: turn head right.
  final String turnRight;

  const KycStrings({
    this.initializing = 'Initializing camera...',
    this.positionFace = 'Position your face in the frame',
    this.moveCloser = 'Move your face closer',
    this.moveCloserHint = 'Bring the phone closer to your face',
    this.holdStill = 'Hold still for a moment',
    this.completed = 'Done',
    this.multipleFaces = 'Keep only one face in the frame',
    this.lookStraight = 'Look straight at the camera',
    this.tooFar = 'Move your face a bit closer',
    this.tooClose = 'Move a little further away',
    this.blink = 'Please blink',
    this.smile = 'Please smile',
    this.turnLeft = 'Please turn your head left',
    this.turnRight = 'Please turn your head right',
  });
}
