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
  String instructions = 'Mueve el dispositivo lentamente para detectar superficies';
  int objectCount = 0;

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
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Vista AR
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          
          // Panel de instrucciones superior
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
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          instructions,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Panel inferior con controles
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  // Contador de objetos
                  if (objectCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.view_in_ar,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Objetos: $objectCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Botón limpiar
                  if (objectCount > 0)
                    ElevatedButton.icon(
                      onPressed: onRemoveEverything,
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('Limpiar Todo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
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

    // Inicializar sesión AR
    arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
      handleTaps: true,
    );

    arObjectManager!.onInitialize();

    // Configurar el listener para toques en pantalla
    arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    
    // Simular detección de superficie
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          surfaceDetected = true;
          instructions = '✅ Listo! Toca la pantalla para colocar un cubo 3D';
        });
      }
    });
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    if (hitTestResults.isEmpty) {
      setState(() {
        instructions = '❌ No se detectó superficie. Intenta de nuevo.';
      });
      return;
    }

    // Obtener el primer resultado válido
    var hitResult = hitTestResults.first;

    try {
      // Crear un nodo 3D (cubo)
      var newNode = ARNode(
        type: NodeType.localGLTF2,
        uri: "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Box/glTF/Box.gltf",
        scale: vector.Vector3(0.15, 0.15, 0.15),
        position: vector.Vector3(
          hitResult.worldTransform.getColumn(3).x,
          hitResult.worldTransform.getColumn(3).y,
          hitResult.worldTransform.getColumn(3).z,
        ),
        rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
      );

      // Agregar el nodo a la escena
      bool? didAddNode = await arObjectManager!.addNode(newNode);
      
      if (didAddNode == true) {
        nodes.add(newNode);
        setState(() {
          objectCount = nodes.length;
          instructions = '🎉 ¡Cubo agregado! Total: $objectCount';
        });
      } else {
        setState(() {
          instructions = '⚠️ Error al agregar el cubo. Intenta de nuevo.';
        });
      }
    } catch (e) {
      setState(() {
        instructions = '⚠️ Error: ${e.toString()}';
      });
      debugPrint('Error al agregar nodo: $e');
    }
  }

  Future<void> onRemoveEverything() async {
    try {
      for (var node in nodes) {
        await arObjectManager?.removeNode(node);
      }
      
      setState(() {
        nodes.clear();
        objectCount = 0;
        instructions = '🧹 Escena limpiada. Toca para agregar más cubos.';
      });
    } catch (e) {
      debugPrint('Error al limpiar: $e');
    }
  }
}