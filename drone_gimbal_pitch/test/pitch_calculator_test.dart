import 'package:drone_gimbal_pitch/pitch_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('45 degrees down when height equals distance', () {
    final pitch = calculateGimbalPitchDegrees(
      heightMeters: 100,
      distanceMeters: 100,
    );
    expect(pitch, closeTo(-45, 0.0001));
  });

  test('near zero when distance is much larger than height', () {
    final pitch = calculateGimbalPitchDegrees(
      heightMeters: 1,
      distanceMeters: 1000,
    );
    expect(pitch, closeTo(0, 1));
    expect(pitch, lessThan(0));
  });
}
