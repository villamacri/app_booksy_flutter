part of 'login_page_bloc.dart';

abstract class LoginPageState {}

class LoginInitial extends LoginPageState {}

class LoginLoading extends LoginPageState {}

class LoginSuccess extends LoginPageState {}

class LoginFailure extends LoginPageState {
  final String error;

  LoginFailure({required this.error});
}