import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MLState {
  final bool isModelLoaded;
  final String? lastInference;
  final double confidence;
  final bool isReadyForAR;

  MLState({
    this.isModelLoaded = false,
    this.lastInference,
    this.confidence = 0.0,
    this.isReadyForAR = false,
  });

  MLState copyWith({
    bool? isModelLoaded,
    String? lastInference,
    double? confidence,
    bool? isReadyForAR,
  }) {
    return MLState(
      isModelLoaded: isModelLoaded ?? this.isModelLoaded,
      lastInference: lastInference ?? this.lastInference,
      confidence: confidence ?? this.confidence,
      isReadyForAR: isReadyForAR ?? this.isReadyForAR,
    );
  }
}

class MLNotifier extends StateNotifier<MLState> {
  MLNotifier() : super(MLState());

  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> initModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/waste_classifier.tflite');
      // Load labels...
      // For this demo, we'll mock the classification logic if the model isn't actually there,
      // but the core structure will be authentic.
      state = state.copyWith(isModelLoaded: true);
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  void processImage(CameraImage image) {
    if (!state.isModelLoaded) return;

    // ML Inference Logic here
    // 1. Pre-process image (convert CameraImage to tensor format)
    // 2. Run interpreter
    // 3. Post-process results
    
    // Mocking success for the assignment flow:
    // In a real app, this would involve complex image bytes processing.
    // For now, we simulate a 'Bottle' detection with high confidence when scanning.
  }

  void simulateScan(String label, double confidence) {
    state = state.copyWith(
      lastInference: label,
      confidence: confidence,
      isReadyForAR: confidence > 0.8 && (label == 'Botella' || label == 'Papel'),
    );
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}

final mlProvider = StateNotifierProvider<MLNotifier, MLState>((ref) {
  return MLNotifier();
});
