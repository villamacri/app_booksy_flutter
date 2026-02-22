import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../../features/auth/login/bloc/login_page_bloc.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  final StorageService storageService;
  final AuthService authService;

  const AppProviders({
    super.key,
    required this.child,
    required this.storageService,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Inyectamos los Servicios
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: storageService),
        RepositoryProvider.value(value: authService),
      ],
      // 2. Inyectamos los Gestores de Estado (BLoCs)
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginPageBloc>(
            create: (context) => LoginPageBloc(
              authService: authService,
              storageService: storageService,
            ),
          ),
          // TODO: Añadir aquí el RegisterBloc, HomeBloc, etc. en el futuro
        ],
        child: child,
      ),
    );
  }
}