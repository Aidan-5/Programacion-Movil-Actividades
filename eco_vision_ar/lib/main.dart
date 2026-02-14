import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'theme/app_theme.dart';
import 'screens/map_screen.dart';
import 'screens/permission_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: EcoVisionApp(),
    ),
  );
}

class EcoVisionApp extends StatefulWidget {
  const EcoVisionApp({super.key});

  @override
  State<EcoVisionApp> createState() => _EcoVisionAppState();
}

class _EcoVisionAppState extends State<EcoVisionApp> {
  bool _ready = false;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final locationStatus = await Permission.location.status;
    final cameraStatus = await Permission.camera.status;

    setState(() {
      _ready = locationStatus.isGranted && cameraStatus.isGranted;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoVision UIDE',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: _checking
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : _ready
              ? const MapScreen()
              : PermissionScreen(
                  onPermissionsGranted: () => setState(() => _ready = true),
                ),
    );
  }
}
