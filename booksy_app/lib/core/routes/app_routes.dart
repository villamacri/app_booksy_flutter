import 'package:booksy_app/core/services/auth_service.dart';
import 'package:booksy_app/core/services/home_service.dart';
import 'package:booksy_app/core/services/storage_service.dart';

import 'package:booksy_app/features/auth/login/bloc/login_page_bloc.dart';
import 'package:booksy_app/features/auth/login/view/login_screen.dart';
import 'package:booksy_app/features/auth/register/view/register_screen.dart';
import 'package:booksy_app/features/home/bloc/home_bloc.dart';
import 'package:booksy_app/features/home/bloc/home_event.dart';
import 'package:booksy_app/features/home/view/navigator_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LoginPageBloc(
              authService: AuthService(),
              storageService: StorageService(),
            ),
            child: const LoginScreen(),
          ),
        );

      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case '/home-user':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                HomeBloc(homeService: HomeService())
                  ..add(FetchHomeData(city: 'Sevilla')),

            child: const NavigatorView(),
          ),
        );

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
