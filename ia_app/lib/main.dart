import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather UI Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherCard Demo'),
      ),
      body: Center(
        child: WeatherCard(
          date: "2025-11-26",
          temperature: "22",
          icon: Icons.wb_sunny,
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------
///  WIDGET GENERADO POR IA (Gemini Code Assist)
// -----------------------------------------------------------

class WeatherCard extends StatelessWidget {
  final String date;
  final String temperature;
  final IconData icon;

  const WeatherCard({
    super.key,
    required this.date,
    required this.temperature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 48),
                Text(
                  "$temperature°C",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
