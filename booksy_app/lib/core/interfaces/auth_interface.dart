import '../models/user/login/login_request.dart';
import '../models/user/login/login_response.dart';
import '../models/user/register/register_request.dart'; // Añadir import

abstract class IAuthService {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> logout(String token);
  
  // Añadir esta línea:
  Future<LoginResponse> register(RegisterRequest request); 
}