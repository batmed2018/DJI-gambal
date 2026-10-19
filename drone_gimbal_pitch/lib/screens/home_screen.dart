import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../calculator/gimbal_pitch.dart';
import '../l10n/app_strings.dart';
import '../models/drone_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.strings,
    required this.onToggleLocale,
  });

  final AppStrings strings;
  final VoidCallback onToggleLocale;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _calculator = GimbalPitchCalculator();

  DroneOption _drone = droneCatalog.first;
  CameraOption _camera = droneCatalog.first.cameras.first;
  final _heightController = TextEditingController();
  final _distanceController = TextEditingController();

  GimbalPitchResult? _result;
  String? _error;

  AppStrings get s => widget.strings;

  @override
  void dispose() {
    _heightController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  void _onDroneChanged(DroneOption? value) {
    if (value == null) return;
    setState(() {
      _drone = value;
      _camera = value.cameras.first;
      _result = null;
      _error = null;
    });
  }

  void _calculate() {
    final height = double.tryParse(_heightController.text.trim());
    final distance = double.tryParse(_distanceController.text.trim());

    setState(() {
      _result = null;
      if (height == null || distance == null || height < 0 || distance < 0) {
        _error = s.invalidNumber;
        return;
      }
      try {
        _result = _calculator.calculate(
          heightMeters: height,
          distanceMeters: distance,
        );
        _error = null;
      } on ArgumentError {
        _error = s.bothZero;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.appTitle),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: TextButton(
              onPressed: widget.onToggleLocale,
              child: Text(s.isArabic ? s.english : s.arabic),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(s.subtitle, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              s.formula,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<DroneOption>(
              value: _drone,
              decoration: InputDecoration(labelText: s.drone),
              items: [
                for (final drone in droneCatalog)
                  DropdownMenuItem(value: drone, child: Text(drone.name)),
              ],
              onChanged: _onDroneChanged,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CameraOption>(
              value: _camera,
              decoration: InputDecoration(labelText: s.camera),
              items: [
                for (final camera in _drone.cameras)
                  DropdownMenuItem(value: camera, child: Text(camera.name)),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _camera = value;
                  _result = null;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(
                labelText: s.height,
                prefixIcon: const Icon(Icons.height),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _distanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(
                labelText: s.distance,
                prefixIcon: const Icon(Icons.straighten),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _calculate,
              icon: const Icon(Icons.calculate_outlined),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(s.calculate),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!, style: TextStyle(color: scheme.error)),
            ],
            if (_result != null) ...[
              const SizedBox(height: 24),
              _ResultCard(
                strings: s,
                result: _result!,
                camera: _camera,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.strings,
    required this.result,
    required this.camera,
  });

  final AppStrings strings;
  final GimbalPitchResult result;
  final CameraOption camera;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inRange =
        result.degrees >= camera.minPitch && result.degrees <= camera.maxPitch;

    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.resultTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              result.formatted,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.signNote,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              inRange ? strings.inRange : strings.outOfRange,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: inRange
                        ? scheme.onPrimaryContainer
                        : scheme.error,
                  ),
            ),
            Text(
              '${camera.minPitch.toStringAsFixed(0)}° … ${camera.maxPitch.toStringAsFixed(0)}°',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onPrimaryContainer,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
