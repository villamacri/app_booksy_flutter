class BookRequest {
  final String titulo;
  final String autor;
  final String? editorial;
  final int? anioEditorial;
  final String? descripcion;
  final String estadoFisico; 
  final String tipoOperacion; 
  final double? precio;
  final String? fechaPublicacion; // Añadido para coincidir con tu BD
  final int categoriaId; 

  BookRequest({
    required this.titulo,
    required this.autor,
    this.editorial,
    this.anioEditorial,
    this.descripcion,
    required this.estadoFisico,
    required this.tipoOperacion,
    this.precio,
    this.fechaPublicacion,
    required this.categoriaId,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'titulo': titulo,
      'autor': autor,
      'estado_fisico': estadoFisico,
      'tipo_operacion': tipoOperacion,
      'categoria_id': categoriaId,
    };

    if (editorial != null && editorial!.isNotEmpty) map['editorial'] = editorial;
    if (anioEditorial != null) map['anio_editorial'] = anioEditorial;
    if (descripcion != null && descripcion!.isNotEmpty) map['descripcion'] = descripcion;
    if (precio != null) map['precio'] = precio;
    if (fechaPublicacion != null) map['fecha_publicacion'] = fechaPublicacion;

    return map;
  }
}