import 'package:kyc_flutter/src/_internal.dart';

/// Public entry point kept for backwards compatibility. Wraps
/// [KycView] in a [Scaffold].
class KycScreen extends StatelessWidget {
  final DetectionConfig config;

  const KycScreen({required this.config, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: KycView(config: config),
    );
  }
}

/// Banking-style face authentication screen.
///
/// Owns the camerawesome preview and pipes each analysis frame into a
/// [DetectionController], which drives the whole flow (position -> hold ->
/// capture far -> move closer -> hold -> capture near -> optional liveness
/// steps). The UI is rebuilt from the controller's state.
///
/// The camera setup mirrors the original working implementation: camerawesome
/// with `previewFit: contain` and a 16:9 sensor. `contain` matters — it keeps
/// the analysis image un-cropped so the NV21 -> InputImage conversion stays
/// valid (a `cover` fit crops the analysis buffer and breaks ML Kit).
class KycView extends StatefulWidget {
  final DetectionConfig config;

  const KycView({required this.config, super.key});

  @override
  State<KycView> createState() => _KycViewState();
}

class _KycViewState extends State<KycView> {
  //* MARK: - Private Variables
  //? =========================================================
  final FaceDetectionService _faceService = FaceDetectionService();
  final CaptureController _captureController = CaptureController();
  late final DetectionController _controller;

  bool _isAnalysing = false;

  //* MARK: - Life Cycle Methods
  //? =========================================================
  @override
  void initState() {
    super.initState();
    _controller = DetectionController(
      config: widget.config,
      capture: _captureController,
      onFinished: _onFinished,
    );
  }

  @override
  void deactivate() {
    _faceService.dispose();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //* MARK: - Analysis
  //? =========================================================
  Future<void> _processCameraImage(AnalysisImage img) async {
    if (_isAnalysing || _controller.phase == FacePhase.completed) return;
    _isAnalysing = true;
    try {
      final InputImage inputImage = img.toInputImage();
      final List<Face> faces = await _faceService.detect(inputImage);
      _controller.onFaces(faces, inputImage.metadata?.size ?? img.size);
    } catch (error) {
      debugPrint('Face analysis error: $error');
    } finally {
      _isAnalysing = false;
    }
  }

  //* MARK: - Flow Result
  //? =========================================================
  void _onFinished(KycResult result) {
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  void _cancel() {
    if (!mounted) return;
    Navigator.of(context).pop(const KycResult(status: KycStatus.cancelled));
  }

  //* MARK: - UI
  //? =========================================================
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildCamera(),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => BankingFaceOverlay(
            strings: widget.config.strings,
            phase: _controller.phase,
            issue: _controller.validation.issue,
            isValid: _controller.validation.isValid,
            stabilityProgress: _controller.stabilityProgress,
            overallProgress: _controller.overallProgress,
            currentLivenessStep: _controller.currentLivenessStep,
          ),
        ),
        _buildManualCapture(),
        _buildCloseButton(),
      ],
    );
  }

  Widget _buildCamera() {
    return CameraAwesomeBuilder.custom(
      previewFit: CameraPreviewFit.contain,
      mirrorFrontCamera: true,
      sensorConfig: SensorConfig.single(
        aspectRatio: CameraAspectRatios.ratio_16_9,
        flashMode: FlashMode.none,
        sensor: Sensor.position(SensorPosition.front),
      ),
      onImageForAnalysis: _processCameraImage,
      imageAnalysisConfig: AnalysisConfig(
        autoStart: true,
        maxFramesPerSecond: 10,
      ),
      builder: (state, preview) {
        _captureController.attach(state);
        // Kick off the flow once the preview is live.
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _controller.start(),
        );
        return const SizedBox.shrink();
      },
      saveConfig: SaveConfig.photo(
        pathBuilder: (_) async {
          final String dir = await getTemporaryDirectory().then(
            (value) => value.path,
          );
          final String fileName = '${Utils.generate()}.jpg';
          return SingleCaptureRequest(
            '$dir/$fileName',
            Sensor.position(SensorPosition.front),
          );
        },
      ),
    );
  }

  Widget _buildManualCapture() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (!_controller.manualCaptureVisible) return const SizedBox.shrink();
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 48),
            child: MaterialButton(
              onPressed: _controller.manualCapture,
              color:
                  widget.config.captureButtonColor ??
                  Theme.of(context).primaryColor,
              textColor: Colors.white,
              padding: const EdgeInsets.all(20),
              shape: const CircleBorder(),
              child: const Icon(Icons.camera_alt, size: 28),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloseButton() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 12, top: 12),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black54,
            child: IconButton(
              onPressed: _cancel,
              icon: const Icon(
                Icons.close_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
