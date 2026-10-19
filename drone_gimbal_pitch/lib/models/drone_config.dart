class CameraOption {
  const CameraOption({
    required this.id,
    required this.name,
    this.minPitch = -90,
    this.maxPitch = 30,
  });

  final String id;
  final String name;
  final double minPitch;
  final double maxPitch;
}

class DroneOption {
  const DroneOption({
    required this.id,
    required this.name,
    required this.cameras,
  });

  final String id;
  final String name;
  final List<CameraOption> cameras;
}

const zenmuseH30T = CameraOption(id: 'h30t', name: 'Zenmuse H30T');
const zenmuseH20T = CameraOption(id: 'h20t', name: 'Zenmuse H20T');
const m30tCam = CameraOption(id: 'm30t-cam', name: 'Matrice 30T Camera');
const m3eCam = CameraOption(id: 'm3e-cam', name: 'Mavic 3 Enterprise Camera');

const droneCatalog = <DroneOption>[
  DroneOption(
    id: 'm350',
    name: 'DJI Matrice 350 RTK',
    cameras: [zenmuseH30T, zenmuseH20T],
  ),
  DroneOption(
    id: 'm30t',
    name: 'DJI Matrice 30T',
    cameras: [m30tCam],
  ),
  DroneOption(
    id: 'm3e',
    name: 'DJI Mavic 3 Enterprise',
    cameras: [m3eCam],
  ),
];
