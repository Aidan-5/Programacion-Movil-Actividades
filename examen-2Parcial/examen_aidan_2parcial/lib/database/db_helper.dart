import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('galeria.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Incrementa la versión para forzar actualización
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE galeria (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        autor TEXT NOT NULL
      )
    ''');
    print('Tabla galeria creada exitosamente');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Elimina la tabla si existe y la vuelve a crear
      await db.execute('DROP TABLE IF EXISTS galeria');
      await _createDB(db, newVersion);
    }
  }

  Future<void> insertarDatosEjemplo(String autorId) async {
    final db = await database;
    
    // Verifica si ya hay datos
    try {
      final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM galeria WHERE autor = ?', [autorId])
      );
      
      if (count != null && count > 0) {
        print('Ya existen $count registros para el autor $autorId');
        return; // Ya hay datos para este autor
      }
    } catch (e) {
      print('Error al verificar datos: $e');
    }

    // Lista de imágenes de ejemplo (Picsum Photos)
    final datos = [
      {'titulo': 'Paisaje Montañoso', 'imageUrl': 'https://picsum.photos/400/300?random=1'},
      {'titulo': 'Atardecer en la Playa', 'imageUrl': 'https://picsum.photos/400/300?random=2'},
      {'titulo': 'Ciudad Nocturna', 'imageUrl': 'https://picsum.photos/400/300?random=3'},
      {'titulo': 'Bosque Verde', 'imageUrl': 'https://picsum.photos/400/300?random=4'},
      {'titulo': 'Arquitectura Moderna', 'imageUrl': 'https://picsum.photos/400/300?random=5'},
      {'titulo': 'Naturaleza Salvaje', 'imageUrl': 'https://picsum.photos/400/300?random=6'},
      {'titulo': 'Mar Tranquilo', 'imageUrl': 'https://picsum.photos/400/300?random=7'},
      {'titulo': 'Montaña Nevada', 'imageUrl': 'https://picsum.photos/400/300?random=8'},
      {'titulo': 'Flores Silvestres', 'imageUrl': 'https://picsum.photos/400/300?random=9'},
      {'titulo': 'Río Cristalino', 'imageUrl': 'https://picsum.photos/400/300?random=10'},
      {'titulo': 'Cascada Majestuosa', 'imageUrl': 'https://picsum.photos/400/300?random=11'},
      {'titulo': 'Desierto Dorado', 'imageUrl': 'https://picsum.photos/400/300?random=12'},
      {'titulo': 'Aurora Boreal', 'imageUrl': 'https://picsum.photos/400/300?random=13'},
      {'titulo': 'Lago Sereno', 'imageUrl': 'https://picsum.photos/400/300?random=14'},
      {'titulo': 'Valle Profundo', 'imageUrl': 'https://picsum.photos/400/300?random=15'},
    ];

    print('Insertando ${datos.length} registros para el autor $autorId');
    
    for (var item in datos) {
      try {
        await db.insert('galeria', {
          'titulo': item['titulo'],
          'imageUrl': item['imageUrl'],
          'autor': autorId,
        });
      } catch (e) {
        print('Error al insertar ${item['titulo']}: $e');
      }
    }
    
    print('Datos insertados correctamente');
  }

  Future<List<Map<String, dynamic>>> obtenerImagenesPorAutor(String autor) async {
    final db = await database;
    return await db.query(
      'galeria',
      where: 'autor = ?',
      whereArgs: [autor],
    );
  }

  Future<void> cerrar() async {
    final db = await database;
    db.close();
  }
}