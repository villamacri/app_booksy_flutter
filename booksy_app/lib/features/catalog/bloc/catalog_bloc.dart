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
    on<SearchCatalog>(_onSearchCatalog);
  }

  Future<void> _onFetchCatalog(
    FetchCatalog event,
    Emitter<CatalogState> emit,
  ) async {
    emit(CatalogLoading());

    try {
      final books = await _bookService.getAllBooks();
      emit(CatalogLoaded(allBooks: books, filteredBooks: books));
    } catch (e) {
      emit(CatalogError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void _onSearchCatalog(SearchCatalog event, Emitter<CatalogState> emit) {
    if (state is! CatalogLoaded) {
      return;
    }

    final currentState = state as CatalogLoaded;
    final normalizedQuery = event.query.trim().toLowerCase();

    final filtered = currentState.allBooks.where((book) {
      final titleMatch = book.titulo.toLowerCase().contains(normalizedQuery);
      final authorMatch = book.autor.toLowerCase().contains(normalizedQuery);
      return titleMatch || authorMatch;
    }).toList();

    emit(
      CatalogLoaded(
        allBooks: currentState.allBooks,
        filteredBooks: filtered,
        query: event.query,
      ),
    );
  }
}
