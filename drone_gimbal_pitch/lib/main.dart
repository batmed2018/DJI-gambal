import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n.dart';
import 'pitch_calculator.dart';

const drones = <String>[
  'DJI Matrice 350 RTK',
  'DJI Matrice 30T',
  'DJI Mavic 3 Enterprise',
];

const cameras = <String>[
  'Zenmuse H30T',
  'Zenmuse H20T',
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GimbalPitchApp());
}

class GimbalPitchApp extends StatefulWidget {
  const GimbalPitchApp({super.key});

  @override
  State<GimbalPitchApp> createState() => _GimbalPitchAppState();
}

class _GimbalPitchAppState extends State<GimbalPitchApp> {
  Locale _locale = const Locale('ar');

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'ar'
          ? const Locale('en')
          : const Locale('ar');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        AppL10nDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F6B5C),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: _locale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
      home: CalculatorPage(onToggleLocale: _toggleLocale),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key, required this.onToggleLocale});

  final VoidCallback onToggleLocale;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String? _drone;
  String? _camera;
  final _heightController = TextEditingController();
  final _distanceController = TextEditingController();
  double? _pitch;
  String? _error;

  @override
  void dispose() {
    _heightController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  void _calculate() {
    final l10n = AppL10n.of(context);
    final heightText = _heightController.text.trim();
    final distanceText = _distanceController.text.trim();

    if (heightText.isEmpty || distanceText.isEmpty) {
      setState(() {
        _pitch = null;
        _error = l10n.errorEmpty;
      });
      return;
    }

    final height = double.tryParse(heightText.replaceAll(',', '.'));
    final distance = double.tryParse(distanceText.replaceAll(',', '.'));

    if (height == null || distance == null || height < 0) {
      setState(() {
        _pitch = null;
        _error = l10n.errorNumber;
      });
      return;
    }

    if (distance <= 0) {
      setState(() {
        _pitch = null;
        _error = l10n.errorDistance;
      });
      return;
    }

    setState(() {
      _error = null;
      _pitch = calculateGimbalPitchDegrees(
        heightMeters: height,
        distanceMeters: distance,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          TextButton(
            onPressed: widget.onToggleLocale,
            child: Text(
              l10n.language,
              style: TextStyle(color: scheme.onSurface),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            DropdownButtonFormField<String>(
              value: _drone,
              decoration: InputDecoration(
                labelText: l10n.droneType,
              ),
              hint: Text(l10n.selectDrone),
              items: [
                for (final drone in drones)
                  DropdownMenuItem(value: drone, child: Text(drone)),
              ],
              onChanged: (value) => setState(() => _drone = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _camera,
              decoration: InputDecoration(
                labelText: l10n.cameraType,
              ),
              hint: Text(l10n.selectCamera),
              items: [
                for (final camera in cameras)
                  DropdownMenuItem(value: camera, child: Text(camera)),
              ],
              onChanged: (value) => setState(() => _camera = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: InputDecoration(
                labelText: l10n.height,
                prefixIcon: const Icon(Icons.height),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _distanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: InputDecoration(
                labelText: l10n.distance,
                prefixIcon: const Icon(Icons.straighten),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _calculate,
              icon: const Icon(Icons.calculate_outlined),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(l10n.calculate),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: scheme.error, fontWeight: FontWeight.w600),
              ),
            ],
            if (_pitch != null) ...[
              const SizedBox(height: 24),
              Card(
                color: scheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.resultTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_pitch!.toStringAsFixed(2)}°',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: scheme.onPrimaryContainer,
                            ),
                      ),
                      Text(
                        '${_pitch!.toStringAsFixed(2)} ${l10n.degrees}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(l10n.negativeNote),
                      const SizedBox(height: 8),
                      Text(
                        l10n.formulaNote,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
