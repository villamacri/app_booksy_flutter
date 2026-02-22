import 'package:flutter/material.dart';

import 'core/providers/app_providers.dart';
import 'core/services/auth_service.dart';
import 'core/services/storage_service.dart';
import 'features/auth/login/view/login_screen.dart';

void main() async {
  // Inicialización crítica de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Instanciamos los servicios core (Singleton visual)
  final storageService = StorageService();
  final authService = AuthService();

  // Arrancamos la app envuelta en nuestro inyector de dependencias
  runApp(
    AppProviders(
      storageService: storageService,
      authService: authService,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RepoBooksy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // Pantalla inicial
      home: const LoginScreen(),
    );
  }
}
