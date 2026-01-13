class ImagenModelo {
  final int? id;
  final String titulo;
  final String imageUrl;
  final String autor;

  ImagenModelo({
    this.id,
    required this.titulo,
    required this.imageUrl,
    required this.autor,
  });

  factory ImagenModelo.fromMap(Map<String, dynamic> map) {
    return ImagenModelo(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      imageUrl: map['imageUrl'] as String,
      autor: map['autor'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'imageUrl': imageUrl,
      'autor': autor,
    };
  }
}