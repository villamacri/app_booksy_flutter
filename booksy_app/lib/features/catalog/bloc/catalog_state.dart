import 'package:booksy_app/core/models/book/book_response.dart';

typedef Book = BookResponse;

abstract class CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<Book> allBooks;
  final List<Book> filteredBooks;
  final String query;

  CatalogLoaded({
    required this.allBooks,
    required this.filteredBooks,
    this.query = '',
  });
}

class CatalogError extends CatalogState {
  final String message;

  CatalogError(this.message);
}
