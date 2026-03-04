import 'package:booksy_app/core/models/book/book_response.dart';

abstract class BookState {}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<BookResponse> books;

  BookLoaded(this.books);
}

class BookError extends BookState {
  final String message;

  BookError(this.message);
}
