abstract class TransactionEvent {}

class SubmitTransaction extends TransactionEvent {
  final int bookId;
  final String type;

  SubmitTransaction({required this.bookId, required this.type});
}
