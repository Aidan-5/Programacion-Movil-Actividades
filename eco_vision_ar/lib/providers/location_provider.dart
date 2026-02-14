import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vector_math/vector_math.dart';

class LocationState {
  final Position? currentPosition;
  final double distanceToTarget;
  final bool isWithinRange; // < 5m
  final bool permissionsGranted;
  final int gpsRequestCount;
  final double accuracy;

  LocationState({
    this.currentPosition,
    this.distanceToTarget = double.infinity,
    this.isWithinRange = false,
    this.permissionsGranted = false,
    this.gpsRequestCount = 0,
    this.accuracy = 0,
  });

  LocationState copyWith({
    Position? currentPosition,
    double? distanceToTarget,
    bool? isWithinRange,
    bool? permissionsGranted,
    int? gpsRequestCount,
    double? accuracy,
  }) {
    return LocationState(
      currentPosition: currentPosition ?? this.currentPosition,
      distanceToTarget: distanceToTarget ?? this.distanceToTarget,
      isWithinRange: isWithinRange ?? this.isWithinRange,
      permissionsGranted: permissionsGranted ?? this.permissionsGranted,
      gpsRequestCount: gpsRequestCount ?? this.gpsRequestCount,
      accuracy: accuracy ?? this.accuracy,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState());

  static const double targetLat = -3.9822; // UIDE Loja Labs
  static const double targetLng = -79.2023;
  
  StreamSubscription<Position>? _positionStream;
  Timer? _optimizationTimer;

  Future<void> startTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    state = state.copyWith(permissionsGranted: true);
    _initDynamicTracking();
  }

  void _initDynamicTracking() {
    // Basic implementation of energy optimization:
    // Every X seconds, check distance and decide frequency.
    _optimizationTimer?.cancel();
    _optimizationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _adjustSamplingRate();
    });
    
    _listenToPosition(LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1, // Update every 1 meter
    ));
  }

  void _adjustSamplingRate() {
    if (state.currentPosition == null) return;

    final distance = state.distanceToTarget;
    LocationSettings settings;

    if (distance > 100) {
      // Far: Low frequency
      settings = const LocationSettings(accuracy: LocationAccuracy.medium, distanceFilter: 10);
    } else if (distance > 20) {
      // Approaching: High accuracy, moderate filter
      settings = const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 2);
    } else {
      // Very Close: Precision mode
      settings = const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 0);
    }

    _listenToPosition(settings);
  }

  void _listenToPosition(LocationSettings settings) {
    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(locationSettings: settings).listen((Position position) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        targetLat,
        targetLng,
      );

      state = state.copyWith(
        currentPosition: position,
        distanceToTarget: distance,
        isWithinRange: distance < 5.0 && position.accuracy < 10, // Requirement: < 5m
        gpsRequestCount: state.gpsRequestCount + 1,
        accuracy: position.accuracy,
      );
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _optimizationTimer?.cancel();
    super.dispose();
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});
