# kyc_flutter example

A minimal app showing how to run the KYC flow and read the result.

```bash
cd example
flutter pub get
flutter run
```

Tap **Start KYC**, complete the flow, and the captured images appear in a grid
labelled by capture type / liveness step. See [`lib/main.dart`](lib/main.dart).

> Make sure camera permissions are set up (see the package README).
