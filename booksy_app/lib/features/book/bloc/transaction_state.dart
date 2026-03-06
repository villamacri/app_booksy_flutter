abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionSuccess extends TransactionState {}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);
}
