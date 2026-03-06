import 'package:booksy_app/core/services/book_service.dart';
import 'package:booksy_app/features/book/bloc/add_book_event.dart';
import 'package:booksy_app/features/book/bloc/add_book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBookBloc extends Bloc<AddBookEvent, AddBookState> {
  final BookService _bookService;

  AddBookBloc({required BookService bookService})
    : _bookService = bookService,
      super(AddBookInitial()) {
    on<SubmitBook>(_onSubmitBook);
  }

  Future<void> _onSubmitBook(
    SubmitBook event,
    Emitter<AddBookState> emit,
  ) async {
    emit(AddBookLoading());

    try {
      await _bookService.createBook(event.bookData);
      emit(AddBookSuccess());
    } catch (e) {
      emit(AddBookError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
