import 'package:kyc_flutter/src/_internal.dart';

/// The full-screen banking-style overlay drawn on top of the camera preview:
/// a dimmed scrim with an oval cut-out, an oval border, a capture progress ring
/// that fills as the face is held steady, and the instructional hint text.
class BankingFaceOverlay extends StatelessWidget {
  const BankingFaceOverlay({
    super.key,
    required this.strings,
    required this.phase,
    required this.issue,
    required this.isValid,
    required this.stabilityProgress,
    required this.overallProgress,
    required this.currentLivenessStep,
  });

  final KycStrings strings;
  final FacePhase phase;
  final FaceIssue issue;
  final bool isValid;
  final double stabilityProgress;
  final double overallProgress;
  final KycStep? currentLivenessStep;

  static const Color _validColor = Color(0xFF34D399);
  static const Color _waitingColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final Color accent = isValid ? _validColor : _waitingColor;
    final Rect oval = FaceOverlayLayout.ovalRect(MediaQuery.sizeOf(context));

    return Stack(
      fit: StackFit.expand,
      children: [
        // Scrim + oval border + capture ring.
        CustomPaint(
          painter: _OvalOverlayPainter(
            accent: accent,
            progress: stabilityProgress,
          ),
        ),
        // Top overall progress bar.
        Positioned(
          bottom: 80,
          left: 24,
          right: 24,
          child: _OverallProgressBar(progress: overallProgress),
        ),
        // Hint text just below the oval.
        Positioned(
          top: oval.bottom + 28,
          left: 32,
          right: 32,
          child: Column(
            children: [
              Text(
                _title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              if (_subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  _subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// The primary instruction for the current phase/issue.
  String get _title {
    switch (phase) {
      case FacePhase.initializing:
        return strings.initializing;
      case FacePhase.positioningFar:
      case FacePhase.stabilizingFar:
        return _issueText ?? strings.positionFace;
      case FacePhase.moveCloser:
      case FacePhase.stabilizingNear:
        return _issueText ?? strings.moveCloser;
      case FacePhase.liveness:
        return _livenessText;
      case FacePhase.completed:
        return strings.completed;
    }
  }

  String? get _subtitle {
    switch (phase) {
      case FacePhase.stabilizingFar:
      case FacePhase.stabilizingNear:
        return strings.holdStill;
      case FacePhase.moveCloser:
        return issue == FaceIssue.tooFar ? strings.moveCloserHint : null;
      default:
        return null;
    }
  }

  /// Human hint for the blocking issue, or `null` when the face is valid.
  String? get _issueText {
    if (isValid) return null;
    switch (issue) {
      case FaceIssue.noFace:
        return strings.positionFace;
      case FaceIssue.multipleFaces:
        return strings.multipleFaces;
      case FaceIssue.notStraight:
        return strings.lookStraight;
      case FaceIssue.tooFar:
        return phase == FacePhase.moveCloser ||
                phase == FacePhase.stabilizingNear
            ? strings.moveCloser
            : strings.tooFar;
      case FaceIssue.tooClose:
        return strings.tooClose;
      case FaceIssue.none:
        return null;
    }
  }

  String get _livenessText {
    switch (currentLivenessStep) {
      case KycStep.blink:
        return strings.blink;
      case KycStep.smile:
        return strings.smile;
      case KycStep.turnLeft:
        return strings.turnLeft;
      case KycStep.turnRight:
        return strings.turnRight;
      case null:
        return strings.lookStraight;
    }
  }
}

/// Paints the dark scrim with an oval hole, the oval border and the capture
/// progress ring around it.
class _OvalOverlayPainter extends CustomPainter {
  _OvalOverlayPainter({required this.accent, required this.progress});

  final Color accent;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect oval = FaceOverlayLayout.ovalRect(size);

    // Scrim with the oval punched out.
    final Path scrim = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()..addOval(oval),
    );
    canvas.drawPath(
      scrim,
      Paint()..color = Colors.black.withValues(alpha: 0.6),
    );

    // Base oval border.
    canvas.drawOval(
      oval,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = accent.withValues(alpha: 0.45),
    );

    // Capture progress ring (starts at the top, sweeps clockwise).
    if (progress > 0) {
      canvas.drawArc(
        oval,
        -pi / 2,
        2 * pi * progress.clamp(0.0, 1.0),
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 6
          ..color = accent,
      );
    }
  }

  @override
  bool shouldRepaint(_OvalOverlayPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.accent != accent;
}

/// A slim rounded progress bar shown at the top of the screen.
class _OverallProgressBar extends StatelessWidget {
  const _OverallProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 6,
        backgroundColor: Colors.white.withValues(alpha: 0.25),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
      ),
    );
  }
}
