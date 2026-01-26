import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Color de fondo azul claro de la imagen
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FC), 
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Añadimos más espacio arriba (top) para separarlo de la cámara
            padding: const EdgeInsets.only(top: 60.0, left: 24.0, right: 24.0, bottom: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- SECCIÓN SUPERIOR: Logo y Títulos ---
                Container(
                  padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B9EE1), // Azul del logo
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'BookExchange',
                style: TextStyle(
                  color: Color(0xFF5B9EE1),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Panel de Administración',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),

              // --- TARJETA CENTRAL (CARD BLANCA) ---
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ingresa tus credenciales para continuar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Label Email
                    const Text(
                      'Correo electrónico',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Campo Email
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'admin@bookexchange.com',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.mail_outline, color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Label Contraseña
                    const Text(
                      'Contraseña',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Campo Contraseña
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: TextStyle(color: Colors.grey[400], letterSpacing: 2),
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                        suffixIcon: const Icon(Icons.remove_red_eye_outlined, color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Recordarme y Olvidaste
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: false,
                            shape: const CircleBorder(),
                            activeColor: const Color(0xFF5B9EE1),
                            onChanged: (value) {},
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Recordarme',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            '¿Olvidaste?',
                            style: TextStyle(
                              color: Color(0xFF5B9EE1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Botón Iniciar Sesión Brillante
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B9EE1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Separador
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'o',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Texto Registrarse
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         const Text(
                          '¿No tienes cuenta? ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: const Text(
                            'Regístrate',
                            style: TextStyle(
                              color: Color(0xFF5B9EE1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // --- PILLS / CHIPS INFERIORES ---
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _buildBottomPill('Gestión de usuarios'),
                  _buildBottomPill('Control de transacciones'),
                  _buildBottomPill('Reportes detallados'),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  // Widget auxiliar para las etiquetas inferiores (Pills)
  Widget _buildBottomPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, size: 16, color: Color(0xFF5B9EE1)),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


