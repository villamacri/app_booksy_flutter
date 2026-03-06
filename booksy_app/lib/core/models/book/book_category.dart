class BookCategory {
  final int id;
  final String name;

  const BookCategory({required this.id, required this.name});

  factory BookCategory.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawName = json['name'] ?? json['title'] ?? json['category'];

    final id = rawId is int ? rawId : int.tryParse(rawId.toString()) ?? 0;
    final name = rawName?.toString().trim() ?? '';

    return BookCategory(id: id, name: name.isEmpty ? 'Categoria $id' : name);
  }
}
