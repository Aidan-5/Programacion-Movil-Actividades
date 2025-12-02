import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 88, color: Colors.amber),

            SizedBox(height: 30),

            Text('Welcome', style: TextStyle(fontSize: 24)),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, 'details');
              },
              label: Text('Ir a detalless'),
              icon: Icon(Icons.info),
            ),

            SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, 'settings');
              },
              label: Text('Configuracion'),
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
