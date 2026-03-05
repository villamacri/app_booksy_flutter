import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  // Guardar el Token de Sanctum
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Leer el Token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Guardar el Rol del usuario (user, moderator, admin)
  Future<void> saveRole(String role) async {
    await _storage.write(key: 'user_role', value: role);
  }

  // Leer el Rol para saber a qué pantalla mandarlo
  Future<String?> getRole() async {
    return await _storage.read(key: 'user_role');
  }

  // Borrar todo al hacer Logout
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
