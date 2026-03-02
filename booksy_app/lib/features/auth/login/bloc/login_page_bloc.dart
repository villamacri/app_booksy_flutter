import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/interfaces/auth_interface.dart';
import '../../../../core/models/user/login/login_request.dart';
import '../../../../core/services/storage_service.dart';

part 'login_page_event.dart';
part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  final IAuthService _authService;
  final StorageService _storageService;

  LoginPageBloc({
    required IAuthService authService,
    required StorageService storageService,
  }) : _authService = authService,
       _storageService = storageService,
       super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginPageState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final request = LoginRequest(
        email: event.email,
        password: event.password,
      );

      final response = await _authService.login(request);

      await _storageService.saveToken(response.token);

      emit(LoginSuccess());
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(LoginFailure(error: errorMessage));
    }
  }
}
