## 0.2.0

* **Breaking:** renamed the `KYC`-prefixed public types to `Kyc` for naming
  consistency — `KYCFlutter` → `KycFlutter`, `KYCStep` → `KycStep`. Update call
  sites, e.g. `KycFlutter.instance.startKyc(...)` and `steps: [KycStep.blink]`.
* Removed the `uuid` dependency — captured-image file names are now generated
  internally, shrinking the package's dependency footprint.
* Added an Android troubleshooting note: AGP 9.x breaks the ML Kit
  face-detection native library; pin AGP to the stable 8.x line.
* Added a demo GIF to the README.

## 0.1.0

Initial release.

* One-call API: `KycFlutter.instance.startKyc(context, config: ...)`.
* Mandatory look-straight framing captures (far, then near) run first.
* Optional liveness challenges: blink, smile, turn left, turn right.
* Structured `KycResult` output with a status (`success` / `cancelled` /
  `timeout`) and images tagged by capture type and liveness step.
* Fully customizable on-screen text via `KycStrings` (English by default).
* Configurable thresholds and hold durations via `DetectionConfig`, including
  `smileThreshold`.
