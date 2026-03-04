class BookResponse {
  final int id;
  final String titulo;
  final String autor;
  final String? editorial;
  final int? anioEditorial;
  final String? descripcion;
  final String estadoFisico;
  final String tipoOperacion;
  final double? precio;
  final int categoriaId;
  final int usuarioId; // Importante para saber de quién es el libro
  final String estadoLibro; // ej: 'available', 'exchanged'

  BookResponse({
    required this.id,
    required this.titulo,
    required this.autor,
    this.editorial,
    this.anioEditorial,
    this.descripcion,
    required this.estadoFisico,
    required this.tipoOperacion,
    this.precio,
    required this.categoriaId,
    required this.usuarioId,
    required this.estadoLibro,
  });

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    return BookResponse(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      titulo: json['title'] ?? 'Sin título',
      autor: json['author'] ?? 'Autor desconocido',
      editorial: json['publisher'],
      anioEditorial: json['publication_year'] is String ? int.parse(json['publication_year']) : json['publication_year'],
      descripcion: json['description'],
      estadoFisico: json['condition'] ?? 'used',
      tipoOperacion: json['operation_type'] ?? 'exchange',
      precio: json['price'] != null ? double.parse(json['price'].toString()) : null,
      categoriaId: json['category_id'] is String ? int.parse(json['category_id']) : json['category_id'],
      usuarioId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'],
      estadoLibro: json['status'] ?? 'available',
    );
  }

  static List<BookResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => BookResponse.fromJson(json)).toList();
  }
}