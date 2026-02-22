import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_page_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    // 1. Validamos visualmente que no haya campos vacíos
    if (_formKey.currentState!.validate()) {
      
      // 2. Disparamos el evento hacia nuestro BLoC
      context.read<LoginPageBloc>().add(
        LoginSubmitted(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Envolvemos el contenido en un BlocConsumer
        child: BlocConsumer<LoginPageBloc, LoginPageState>(
          listener: (context, state) {
            // --- REACCIONES INVISIBLES (Navegación, Alertas) ---
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is LoginSuccess) {
              // Limpiamos el teclado
              FocusScope.of(context).unfocus();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Bienvenido a RepoBooksy!'),
                  backgroundColor: Colors.green,
                ),
              );
              
              // TODO: Navegar a la pantalla del Catálogo (Home)
              // Navigator.pushReplacementNamed(context, '/home');
            }
          },
          builder: (context, state) {
            // --- REDIBUJADO VISUAL ---
            // Extraemos la variable para saber si estamos cargando
            final isLoading = state is LoginLoading;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.menu_book_rounded, size: 80, color: Colors.blueAccent),
                      const SizedBox(height: 16),
                      const Text(
                        'RepoBooksy',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Accede a tu catálogo virtual',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 48),

                      // Campo Email (Se deshabilita mientras carga)
                      TextFormField(
                        controller: _emailController,
                        enabled: !isLoading, 
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Correo Electrónico',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'El correo es obligatorio';
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Introduce un correo válido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Campo Contraseña (Se deshabilita mientras carga)
                      TextFormField(
                        controller: _passwordController,
                        enabled: !isLoading,
                        obscureText: _isObscured,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _onLoginPressed(),
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                            onPressed: () => setState(() => _isObscured = !_isObscured),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'La contraseña es obligatoria';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Botón Principal Inteligente
                      SizedBox(
                        height: 52, // Altura fija para evitar saltos visuales al cambiar a spinner
                        child: FilledButton(
                          onPressed: isLoading ? null : _onLoginPressed,
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          // Si está cargando, mostramos spinner; si no, el texto
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text('INICIAR SESIÓN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: isLoading ? null : () {}, // Deshabilitado durante la carga
                        child: const Text('¿No tienes cuenta? Regístrate'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}