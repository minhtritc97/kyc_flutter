/// Optional liveness challenges a consumer can add to the flow.
///
/// The "look straight" framing captures (far then near) always run first and
/// are not part of this enum — they are mandatory. These steps run afterwards,
/// in the order they are listed in [DetectionConfig.steps].
enum KYCStep { blink, smile, turnLeft, turnRight }
