import 'package:flutter/material.dart';
import 'form_screen.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _returnedData = 'Sin dato';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configuracion')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 80, color: Colors.grey),

            SizedBox(height: 20),

            Text(
              'Valor retornado: $_returnedData',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormScreen()),
                );
                if (result != null) {
                  setState(() {
                    _returnedData = result;
                  });
                }
              },
              label: Text('Abrir Formulario'),
              icon: Icon(Icons.input),
            ),
            SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              label: Text('Regresar'),
              icon: Icon(Icons.arrow_back),
            ),
          ],
        ),
      ),
    );
  }
}
