import 'package:booksy_app/core/services/book_service.dart';
import 'package:booksy_app/features/book/bloc/book_page_event.dart';
import 'package:booksy_app/features/book/bloc/book_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookService _bookService;

  BookBloc({required BookService bookService})
    : _bookService = bookService,
      super(BookInitial()) {
    on<FetchBooks>(_onFetchBooks);
  }

  Future<void> _onFetchBooks(FetchBooks event, Emitter<BookState> emit) async {
    emit(BookLoading());
    try {
      final books = await _bookService.getAllBooks();
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
