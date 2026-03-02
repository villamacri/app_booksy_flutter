part of 'register_bloc.dart';

abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String nombre;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? organizacion;

  RegisterSubmitted({
    required this.nombre,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.organizacion,
  });
}