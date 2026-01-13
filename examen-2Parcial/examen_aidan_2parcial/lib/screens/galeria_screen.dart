import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../database/db_helper.dart';
import '../models/imagen_modelo.dart';

class GaleriaScreen extends StatefulWidget {
  const GaleriaScreen({Key? key}) : super(key: key);

  @override
  State<GaleriaScreen> createState() => _GaleriaScreenState();
}

class _GaleriaScreenState extends State<GaleriaScreen> {
  // ⚠️ MODIFICA ESTO CON TUS DATOS
  final String miAutorId = 'Aidan Carpio ;-)'; // Ejemplo: 'JP-5'
  
  List<ImagenModelo> imagenes = [];
  bool isLoading = true;
  bool datosYaCargados = false;

  @override
  void initState() {
    super.initState();
    _cargarImagenes();
  }

  Future<void> _cargarImagenes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final db = DatabaseHelper.instance;
      final data = await db.obtenerImagenesPorAutor(miAutorId);
      
      setState(() {
        imagenes = data.map((map) => ImagenModelo.fromMap(map)).toList();
        datosYaCargados = imagenes.isNotEmpty;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar imágenes: $e')),
      );
    }
  }

  Future<void> _cargarDatosEjemplo() async {
    try {
      final db = DatabaseHelper.instance;
      await db.insertarDatosEjemplo(miAutorId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos cargados exitosamente')),
      );
      
      await _cargarImagenes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería desde SQLite'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Encabezado con el autor
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.deepPurple.shade50,
            child: Column(
              children: [
                Text(
                  'Autor: $miAutorId',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                if (!datosYaCargados && !isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton.icon(
                      onPressed: _cargarDatosEjemplo,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('Cargar Datos de Ejemplo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Lista de imágenes
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : imagenes.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay imágenes.\nPresiona el botón para cargar datos.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: imagenes.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final imagen = imagenes[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Imagen con caché
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: imagen.imageUrl,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.error,
                                        size: 50,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                // Título
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        imagen.titulo,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'ID: ${imagen.id} | Autor: ${imagen.autor}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}