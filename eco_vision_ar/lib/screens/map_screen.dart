import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/location_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/radar_indicator.dart';
import 'camera_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  
  static const LatLng _targetCenter = LatLng(
    LocationNotifier.targetLat,
    LocationNotifier.targetLng,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationProvider.notifier).startTracking();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("GEO-LOCALIZACIÓN DE CRISIS"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "GPS TRAPS: ${locationState.gpsRequestCount}",
                  style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                ),
                Text(
                  "PREC: ${locationState.accuracy.toStringAsFixed(1)}m",
                  style: const TextStyle(fontSize: 10, color: AppTheme.secondaryCyan),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _targetCenter,
              zoom: 18,
            ),
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.dark,
            markers: {
              const Marker(
                markerId: MarkerId("crisis_foci"),
                position: _targetCenter,
                infoWindow: InfoWindow(title: "FOCO DE CONTAMINACIÓN"),
              ),
            },
            circles: {
              Circle(
                circleId: const CircleId("safety_zone"),
                center: _targetCenter,
                radius: 5,
                fillColor: AppTheme.primaryGreen.withOpacity(0.1),
                strokeColor: AppTheme.primaryGreen,
                strokeWidth: 1,
              ),
            },
          ),
          
          // Radar Overlay
          Positioned(
            bottom: 40,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundDark.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.secondaryCyan.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  RadarIndicator(distance: locationState.distanceToTarget),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "DISTANCIA AL OBJETIVO",
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 10),
                      ),
                      Text(
                        locationState.distanceToTarget == double.infinity
                            ? "BUSCANDO..."
                            : "${locationState.distanceToTarget.toStringAsFixed(1)} m",
                        style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Intervention Button
          Positioned(
            bottom: 40,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: locationState.isWithinRange
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CameraScreen()),
                      );
                    }
                  : null,
              backgroundColor: locationState.isWithinRange
                  ? AppTheme.primaryGreen
                  : Colors.grey.withOpacity(0.5),
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: Text(
                locationState.isWithinRange ? "INICIAR RECONOCIMIENTO" : "FUERA DE RANGO",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
