import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulario')),
      body: Column(
        children: [
          Text('Ingresa tu nombre', style: TextStyle(fontSize: 18)),

          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ingresa tu nombre',
            ),
          ),

          SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context, _controller.text);
            },
            icon: Icon(Icons.send),
            label: Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
