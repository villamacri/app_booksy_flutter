import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/interfaces/auth_interface.dart';
import '../../../../core/models/user/login/login_request.dart';
import '../../../../core/services/storage_service.dart';

part 'login_page_event.dart';
part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  final IAuthService _authService;
  final StorageService _storageService;

  // Inyectamos los servicios a través del constructor (Buenas prácticas)
  LoginPageBloc({
    required IAuthService authService,
    required StorageService storageService,
  }) : _authService = authService,
       _storageService = storageService,
       super(LoginInitial()) {
    // Mapeamos el evento a su función manejadora
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginPageState> emit,
  ) async {
    // 1. Avisamos a la UI que empiece a mostrar el spinner
    emit(LoginLoading());

    try {
      // 2. Preparamos el DTO con los datos del evento
      final request = LoginRequest(
        email: event.email,
        password: event.password,
      );

      // 3. Ejecutamos la petición HTTP a Laravel
      final response = await _authService.login(request);

      // 4. Si llegamos aquí, fue un 200 OK. Guardamos el token encriptado.
      await _storageService.saveToken(response.token);

      // 5. Avisamos a la UI del éxito
      emit(LoginSuccess());
    } catch (e) {
      // Si el AuthService lanza una Exception (ej. 401 Credenciales incorrectas)
      // Limpiamos el texto por defecto de Dart y emitimos el error a la UI
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(LoginFailure(error: errorMessage));
    }
  }
}
