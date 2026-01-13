import 'package:flutter/material.dart';
import 'screens/galeria_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galería SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, // Cambiado a un MaterialColor válido
        useMaterial3: true,
      ),
      home: const GaleriaScreen(),
    );
  }
}