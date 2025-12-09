import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARViewScreen extends StatefulWidget {
  const ARViewScreen({super.key});

  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  
  List<ARNode> nodes = [];
  bool surfaceDetected = false;
  String instructions = 'Mueve el dispositivo para detectar superficies';

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello World AR'),
        backgroundColor: Colors.blue.withOpacity(0.8),
        elevation: 0,
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontal,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        surfaceDetected ? Icons.check_circle : Icons.search,
                        color: surfaceDetected ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          instructions,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (surfaceDetected) ...[
                    const SizedBox(height: 8),
                    const Text(
                      '👆 Toca la pantalla para colocar un cubo',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  if (nodes.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Objetos colocados: ${nodes.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: nodes.isEmpty ? null : onRemoveEverything,
                    icon: const Icon(Icons.delete_sweep),
                    label: const Text('Limpiar Todo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;
    arAnchorManager = anchorManager;

    arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
      handleTaps: true,
      handlePans: false,
      handleRotation: false,
    );

    arObjectManager!.onInitialize();

    // Listener para detección de planos
    arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    
    // Simular detección de superficie después de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          surfaceDetected = true;
          instructions = '¡Superficie detectada!';
        });
      }
    });
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    // Filtrar resultados para obtener solo planos horizontales
    var singleHitTestResult = hitTestResults.firstWhere(
      (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane,
      orElse: () => hitTestResults.first,
    );

    // Crear un nuevo nodo (cubo) en la posición detectada
    var newNode = ARNode(
      type: NodeType.localGLTF2,
      uri: "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Box/glTF/Box.gltf",
      scale: vector.Vector3(0.2, 0.2, 0.2),
      position: vector.Vector3(
        singleHitTestResult.worldTransform.getColumn(3).x,
        singleHitTestResult.worldTransform.getColumn(3).y,
        singleHitTestResult.worldTransform.getColumn(3).z,
      ),
      rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
    );

    bool didAddNode = await arObjectManager!.addNode(newNode) ?? false;
    
    if (didAddNode) {
      nodes.add(newNode);
      setState(() {
        instructions = '¡Cubo colocado! Toca de nuevo para agregar más';
      });
    }
  }

  Future<void> onRemoveEverything() async {
    for (var node in nodes) {
      await arObjectManager?.removeNode(node);
    }
    
    setState(() {
      nodes.clear();
      instructions = 'Toca la pantalla para colocar un cubo';
    });
  }
}