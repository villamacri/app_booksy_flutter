
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:booksy_app/core/interfaces/auth_interface.dart';
import 'package:booksy_app/core/models/user/register/register_request.dart';
import 'package:booksy_app/core/services/storage_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final IAuthService authService;
  final StorageService storageService;

  RegisterBloc({
    required this.authService,
    required this.storageService,
  }) : super(RegisterInitial()) {
    
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    try {
      final request = RegisterRequest(
        nombre: event.nombre,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        organizacion: event.organizacion,
      );

      final response = await authService.register(request);

      await storageService.saveToken(response.token);

      emit(RegisterSuccess());
      
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      emit(RegisterFailure(error: errorMsg));
    }
  }
}