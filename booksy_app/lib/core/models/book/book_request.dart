class BookRequest {
  final String titulo;
  final String autor;
  final String? editorial;
  final int? anioEditorial;
  final String? descripcion;
  final String estadoFisico; 
  final String tipoOperacion; 
  final double? precio;
  final String? fechaPublicacion; 
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
      'title': titulo,
      'author': autor,
      'condition': estadoFisico,
      'operation_type': tipoOperacion, 
      'category_id': categoriaId,
    };

    if (editorial != null && editorial!.isNotEmpty) map['publisher'] = editorial;
    if (anioEditorial != null) map['publication_year'] = anioEditorial;
    if (descripcion != null && descripcion!.isNotEmpty) map['description'] = descripcion;
    if (precio != null) map['price'] = precio;
    if (fechaPublicacion != null) map['published_date'] = fechaPublicacion;

    return map;
  }
}