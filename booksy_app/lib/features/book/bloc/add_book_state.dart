abstract class AddBookState {}

class AddBookInitial extends AddBookState {}

class AddBookLoading extends AddBookState {}

class AddBookSuccess extends AddBookState {}

class AddBookError extends AddBookState {
  final String message;

  AddBookError(this.message);
}
