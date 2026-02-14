import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ml_provider.dart';
import '../theme/app_theme.dart';
import 'ar_screen.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  CameraController? _cameraController;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
    ref.read(mlProvider.notifier).initModel();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await _cameraController!.initialize();
    
    // Start streaming images to ML
    _cameraController!.startImageStream((image) {
      ref.read(mlProvider.notifier).processImage(image);
    });

    if (mounted) setState(() => _isInit = true);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mlState = ref.watch(mlProvider);

    return Scaffold(
      body: Stack(
        children: [
          if (_isInit)
            SizedBox.expand(child: CameraPreview(_cameraController!))
          else
            const Center(child: CircularProgressIndicator()),

          // Cyber UI Overlay
          _buildScannerUI(mlState),

          // ML Info
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryGreen),
              ),
              child: Column(
                children: [
                  const Text("VISIÓN ARTIFICIAL ACTIVA",
                      style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    "OBJETO: ${mlState.lastInference ?? 'ESCANEANDO...'}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: mlState.confidence,
                    backgroundColor: Colors.white24,
                    color: mlState.confidence > 0.8 ? AppTheme.primaryGreen : Colors.orange,
                  ),
                  Text(
                    "CONFIANZA: ${(mlState.confidence * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // Action Button
          if (mlState.isReadyForAR)
            Positioned(
              bottom: 60,
              left: 50,
              right: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.auto_awesome_rounded),
                label: const Text("INICIAR PROTOCOLO DE LIMPIEZA RA"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ARScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
              ),
            ),

          // For testing purposes in simulation:
          Positioned(
            bottom: 20,
            left: 20,
            child: TextButton(
              onPressed: () => ref.read(mlProvider.notifier).simulateScan("Botella", 0.85),
              child: const Text("Simular Detección (85%)", style: TextStyle(color: Colors.white24)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerUI(MLState mlState) {
    final color = mlState.isReadyForAR ? AppTheme.primaryGreen : AppTheme.secondaryCyan;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Stack(
        children: [
          // Corners
          _buildCorner(0, 0, 0, 0, color),
          _buildCorner(0, 1, 0, 0, color),
          _buildCorner(1, 0, 0, 0, color),
          _buildCorner(1, 1, 0, 0, color),
        ],
      ),
    );
  }

  Widget _buildCorner(double top, double right, double bottom, double left, Color color) {
    return Positioned(
      top: top == 0 ? 40 : null,
      right: right == 0 ? 40 : null,
      bottom: bottom == 0 ? 40 : null,
      left: left == 0 ? 40 : null,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            top: top == 0 ? BorderSide(color: color, width: 4) : BorderSide.none,
            right: right == 0 ? BorderSide(color: color, width: 4) : BorderSide.none,
            bottom: bottom == 0 ? BorderSide(color: color, width: 4) : BorderSide.none,
            left: left == 0 ? BorderSide(color: color, width: 4) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
