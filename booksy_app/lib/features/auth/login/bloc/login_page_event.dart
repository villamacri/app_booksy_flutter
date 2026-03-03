part of 'login_page_bloc.dart';

abstract class LoginPageEvent {}

class LoginSubmitted extends LoginPageEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}
