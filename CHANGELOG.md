## 0.1.0

Initial release.

* One-call API: `KYCFlutter.instance.startKyc(context, config: ...)`.
* Mandatory look-straight framing captures (far, then near) run first.
* Optional liveness challenges: blink, smile, turn left, turn right.
* Structured `KycResult` output with a status (`success` / `cancelled` /
  `timeout`) and images tagged by capture type and liveness step.
* Fully customizable on-screen text via `KycStrings` (English by default).
* Configurable thresholds and hold durations via `DetectionConfig`, including
  `smileThreshold`.
