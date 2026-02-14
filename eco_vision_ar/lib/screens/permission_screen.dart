import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_theme.dart';

class PermissionScreen extends StatelessWidget {
  final VoidCallback onPermissionsGranted;

  const PermissionScreen({super.key, required this.onPermissionsGranted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundDark,
              AppTheme.surfaceDark,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.security_update_warning_rounded,
              size: 100,
              color: AppTheme.dangerRed,
            ),
            const SizedBox(height: 24),
            Text(
              "ACCESO DENEGADO",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.dangerRed,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Para sanar el campus, EcoVision necesita acceso a tu biometría digital (GPS y Cámara). Sin estos permisos, no podemos triangular los focos de contaminación ni proyectar las herramientas de limpieza RA.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.location,
                  Permission.camera,
                ].request();

                if (statuses[Permission.location]!.isGranted &&
                    statuses[Permission.camera]!.isGranted) {
                  onPermissionsGranted();
                } else {
                  openAppSettings();
                }
              },
              child: const Text("RECONFIGURAR PROTOCOLO"),
            ),
          ],
        ),
      ),
    );
  }
}
