import 'package:booksy_app/core/services/book_service.dart';
import 'package:booksy_app/features/catalog/bloc/catalog_event.dart';
import 'package:booksy_app/features/catalog/bloc/catalog_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final BookService _bookService;

  CatalogBloc({required BookService bookService})
    : _bookService = bookService,
      super(CatalogLoading()) {
    on<FetchCatalog>(_onFetchCatalog);
  }

  Future<void> _onFetchCatalog(
    FetchCatalog event,
    Emitter<CatalogState> emit,
  ) async {
    emit(CatalogLoading());

    try {
      final books = await _bookService.getAllBooks();
      emit(CatalogLoaded(books));
    } catch (e) {
      emit(CatalogError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
