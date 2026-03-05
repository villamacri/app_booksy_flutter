abstract class AddBookEvent {}

class SubmitBook extends AddBookEvent {
  final Map<String, dynamic> bookData;

  SubmitBook(this.bookData);
}
