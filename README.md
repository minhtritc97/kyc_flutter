# kyc_flutter

A drop-in Flutter KYC / face-liveness screen. Call one method, the package opens
a full-screen camera flow (banking-style oval overlay), guides the user through
framing their face and optional liveness challenges, and returns the captured
images.

## Features

- One-call API: `KYCFlutter.instance.startKyc(context, config: ...)`.
- Mandatory **look-straight** framing captures (far, then near) run first.
- Optional liveness challenges: **blink, smile, turn left, turn right**.
- Fully customizable on-screen text (`KycStrings`) — English by default.
- Structured `KycResult` output with images tagged by step.

## Getting started

Add the dependency:

```yaml
dependencies:
  kyc_flutter: ^0.1.0
```

### Permissions

The flow uses the camera, so add the platform permissions:

- **iOS** — in `ios/Runner/Info.plist`:
  ```xml
  <key>NSCameraUsageDescription</key>
  <string>Camera is used for face verification.</string>
  ```
- **Android** — in `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.CAMERA" />
  ```

## Usage

```dart
import 'package:kyc_flutter/kyc_flutter.dart';

final KycResult result = await KYCFlutter.instance.startKyc(
  context,
  config: const DetectionConfig(
    // Look-straight far + near always run first; add liveness steps here:
    steps: [KYCStep.blink, KYCStep.smile],
  ),
);

switch (result.status) {
  case KycStatus.success:
    final far = result.farImage;                      // CapturedImage?
    final near = result.nearImage;                    // CapturedImage?
    final blink = result.livenessImages[KYCStep.blink]; // CapturedImage?
    // Use result.images for the full ordered list.
    break;
  case KycStatus.cancelled:
    // User closed the screen.
    break;
  case KycStatus.timeout:
    // Detection did not complete in time.
    break;
}
```

### Configuration (`DetectionConfig`)

| Field | Default | Description |
| --- | --- | --- |
| `steps` | `[]` | Liveness challenges after the far/near captures. |
| `maxSecToDetect` | `null` | Timeout (seconds) for the whole flow; `null` = no limit. |
| `allowAfterMaxSec` | `false` | Show a manual capture button after the timeout. |
| `captureButtonColor` | theme | Color of the manual capture button. |
| `strings` | English | All on-screen text — see `KycStrings`. |
| `farThreshold` / `nearThreshold` | `0.28` / `0.50` | Face-distance thresholds (fraction of frame). |
| `farStableDuration` / `nearStableDuration` | `2.5s` / `2s` | Hold-steady time before capture. |
| `smileThreshold` | `0.5` | Min smiling probability (0..1) for the smile step. |

### Localization

Every string has an English default; override only what you need:

```dart
const DetectionConfig(
  steps: [KYCStep.blink, KYCStep.smile],
  strings: KycStrings(
    positionFace: 'Đưa khuôn mặt vào khung',
    moveCloser: 'Đưa mặt lại gần',
    blink: 'Vui lòng chớp mắt',
    smile: 'Vui lòng mỉm cười',
  ),
);
```

## Example

See [`example/`](example/) for a complete, runnable app.
