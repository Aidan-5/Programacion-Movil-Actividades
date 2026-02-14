import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../theme/app_theme.dart';

class ARScreen extends StatefulWidget {
  const ARScreen({super.key});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARNode? currentRobotNode;
  bool isSanated = false;

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
      handleTaps: true,
    );
    this.arObjectManager!.onInitialize();

    _addCleanerRobot();
  }

  Future<void> _addCleanerRobot() async {
    var newNode = ARNode(
      type: NodeType.localGLTF2,
      uri: "assets/ar/cleaner_bot.glb",
      scale: vector.Vector3(0.5, 0.5, 0.5),
      position: vector.Vector3(0, 0, -1), // 1 meter in front
    );
    bool? didAddNode = await arObjectManager!.addNode(newNode);
    if (didAddNode!) {
      currentRobotNode = newNode;
    }
  }

  void onNodeTap(List<String> nodes) {
    if (nodes.contains(currentRobotNode?.name)) {
      setState(() {
        isSanated = true;
      });
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: const BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          border: Border(top: BorderSide(color: AppTheme.primaryGreen, width: 2)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline, color: AppTheme.primaryGreen, size: 80),
            const SizedBox(height: 16),
            const Text(
              "¡ZONA SANADA!",
              style: TextStyle(
                color: AppTheme.primaryGreen,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white24, height: 32),
            const Text(
              "REPORTE DEL SOLMÁFORO - UIDE LOJA",
              style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 16),
            _buildDataRow("RADIACIÓN UV", "EXTREMA", Colors.purple),
            _buildDataRow("ÍNDICE IUV", "11+", Colors.purple),
            _buildDataRow("RECOMENDACIÓN", "PROTECCIÓN TOTAL", AppTheme.dangerRed),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text("VOLVER AL PANEL DE CONTROL"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textMain)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color),
            ),
            child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MODO INTERVENCIÓN RA")),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            onNodeTap: onNodeTap,
          ),
          if (!isSanated)
            const Positioned(
              top: 20,
              left: 40,
              right: 40,
              child: Container(
                padding: EdgeInsets.all(12),
                color: Colors.black54,
                child: Text(
                  "TOCA EL BOT DE LIMPIEZA PARA ACTIVAR EL PROTOCOLO",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.primaryGreen, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
