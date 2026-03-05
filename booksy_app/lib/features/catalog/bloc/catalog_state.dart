import 'package:booksy_app/core/models/book/book_response.dart';

typedef Book = BookResponse;

abstract class CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<Book> books;

  CatalogLoaded(this.books);
}

class CatalogError extends CatalogState {
  final String message;

  CatalogError(this.message);
}
