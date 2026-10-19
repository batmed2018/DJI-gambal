import 'dart:math' as math;

/// Negative gimbal pitch in degrees: looking down toward the target.
class GimbalPitchResult {
  const GimbalPitchResult({
    required this.degrees,
    required this.radians,
  });

  final double degrees;
  final double radians;

  /// DJI-style display, e.g. `-32.5°`.
  String get formatted => '${degrees.toStringAsFixed(1)}°';
}

class GimbalPitchCalculator {
  const GimbalPitchCalculator();

  /// pitch = -atan(height / distance), in degrees.
  ///
  /// The minus sign means the gimbal must tilt down (negative pitch).
  /// If [distance] is 0, the camera is nadir (−90°).
  GimbalPitchResult calculate({
    required double heightMeters,
    required double distanceMeters,
  }) {
    if (heightMeters < 0 || distanceMeters < 0) {
      throw ArgumentError('Height and distance must be >= 0.');
    }
    if (heightMeters == 0 && distanceMeters == 0) {
      throw ArgumentError('Height and distance cannot both be 0.');
    }

    final radians = distanceMeters == 0
        ? -math.pi / 2
        : -math.atan(heightMeters / distanceMeters);
    return GimbalPitchResult(
      degrees: radians * 180 / math.pi,
      radians: radians,
    );
  }
}
