part of 'login_page_bloc.dart';

abstract class LoginPageState {}

/// 1. Estado inicial (el formulario está vacío y esperando)
class LoginInitial extends LoginPageState {}

/// 2. Estado de carga (se debe mostrar un spinner mientras Laravel responde)
class LoginLoading extends LoginPageState {}

/// 3. Estado de éxito (login correcto, listo para navegar)
class LoginSuccess extends LoginPageState {}

/// 4. Estado de error (credenciales incorrectas o fallo de red)
class LoginFailure extends LoginPageState {
  final String error;

  LoginFailure({required this.error});
}