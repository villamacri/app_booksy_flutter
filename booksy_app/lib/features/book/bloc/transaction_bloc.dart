import 'package:booksy_app/core/services/transaction_service.dart';
import 'package:booksy_app/features/book/bloc/transaction_event.dart';
import 'package:booksy_app/features/book/bloc/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionService _transactionService;

  TransactionBloc({required TransactionService transactionService})
    : _transactionService = transactionService,
      super(TransactionInitial()) {
    on<SubmitTransaction>(_onSubmitTransaction);
  }

  Future<void> _onSubmitTransaction(
    SubmitTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    try {
      await _transactionService.createTransaction(
        bookId: event.bookId,
        type: event.type,
      );

      emit(TransactionSuccess());
    } catch (e) {
      emit(TransactionError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
