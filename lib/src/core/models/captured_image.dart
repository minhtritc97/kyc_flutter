import 'dart:convert';

import 'package:kyc_flutter/src/core/enums/kyc_capture_type.dart';
import 'package:kyc_flutter/src/core/enums/kyc_step.dart';

/// A single image captured during the KYC flow, tagged with what it represents.
class CapturedImage {
  /// Absolute path of the saved image file.
  final String imgPath;

  /// `true` when captured automatically by the flow, `false` for a manual tap.
  final bool didCaptureAutomatically;

  /// What this image represents (far / near / liveness / manual).
  final KycCaptureType type;

  /// The liveness step this image belongs to, when [type] is
  /// [KycCaptureType.liveness]; otherwise `null`.
  final KYCStep? step;

  CapturedImage({
    required this.imgPath,
    required this.didCaptureAutomatically,
    this.type = KycCaptureType.manual,
    this.step,
  });

  CapturedImage copyWith({
    String? imgPath,
    bool? didCaptureAutomatically,
    KycCaptureType? type,
    KYCStep? step,
  }) {
    return CapturedImage(
      imgPath: imgPath ?? this.imgPath,
      didCaptureAutomatically:
          didCaptureAutomatically ?? this.didCaptureAutomatically,
      type: type ?? this.type,
      step: step ?? this.step,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{
      'imgPath': imgPath,
      'didCaptureAutomatically': didCaptureAutomatically,
      'type': type.index,
    };
    if (step != null) result['step'] = step!.index;
    return result;
  }

  factory CapturedImage.fromMap(Map<String, dynamic> map) {
    return CapturedImage(
      imgPath: map['imgPath'] ?? '',
      didCaptureAutomatically: map['didCaptureAutomatically'] ?? false,
      type: KycCaptureType.values[map['type'] ?? KycCaptureType.manual.index],
      step: map['step'] != null ? KYCStep.values[map['step']] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CapturedImage.fromJson(String source) =>
      CapturedImage.fromMap(json.decode(source));

  @override
  String toString() =>
      'CapturedImage(imgPath: $imgPath, didCaptureAutomatically: $didCaptureAutomatically, type: $type, step: $step)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CapturedImage &&
        other.imgPath == imgPath &&
        other.didCaptureAutomatically == didCaptureAutomatically &&
        other.type == type &&
        other.step == step;
  }

  @override
  int get hashCode =>
      imgPath.hashCode ^
      didCaptureAutomatically.hashCode ^
      type.hashCode ^
      step.hashCode;
}
