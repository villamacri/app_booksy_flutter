import '../models/user/login/login_request.dart';
import '../models/user/login/login_response.dart';

abstract class IAuthService {
  /// Envía las credenciales al backend y devuelve la respuesta tipada.
  /// Lanza una excepción si las credenciales son inválidas o hay error de red.
  Future<LoginResponse> login(LoginRequest request);

  /// Cierra la sesión en el backend y destruye el token local.
  Future<void> logout(String token);
}
