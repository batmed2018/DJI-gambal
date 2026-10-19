import 'dart:math' as math;

/// Downward gimbal pitch in degrees: −atan(height / distance).
double calculateGimbalPitchDegrees({
  required double heightMeters,
  required double distanceMeters,
}) {
  if (distanceMeters <= 0) {
    throw ArgumentError('distanceMeters must be greater than 0');
  }
  if (heightMeters < 0) {
    throw ArgumentError('heightMeters must be >= 0');
  }
  final radians = math.atan(heightMeters / distanceMeters);
  return -radians * 180 / math.pi;
}
