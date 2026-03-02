import 'package:booksy_app/features/auth/login/view/login_screen.dart';
import 'package:booksy_app/features/auth/register/view/register_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case 'register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
