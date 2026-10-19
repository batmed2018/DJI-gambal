import 'package:drone_gimbal_pitch/calculator/gimbal_pitch.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculator = GimbalPitchCalculator();

  test('45° down when height equals distance', () {
    final result = calculator.calculate(
      heightMeters: 100,
      distanceMeters: 100,
    );
    expect(result.degrees, closeTo(-45, 0.001));
  });

  test('nadir when distance is 0', () {
    final result = calculator.calculate(
      heightMeters: 80,
      distanceMeters: 0,
    );
    expect(result.degrees, closeTo(-90, 0.001));
  });

  test('level when height is 0', () {
    final result = calculator.calculate(
      heightMeters: 0,
      distanceMeters: 50,
    );
    expect(result.degrees, closeTo(0, 0.001));
  });
}
