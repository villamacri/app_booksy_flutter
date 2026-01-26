import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Fondo Azul Claro
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- LOGO SUPERIOR ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[300]!, Colors.blue[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.menu_book_rounded, size: 32, color: Colors.white),
              ),
              const SizedBox(height: 16),
              
              // --- TÍTULOS ---
              Text(
                'BookExchange',
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.blue[600]
                ),
              ),
              Text(
                'Panel de Administración',
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.grey[600]
                ),
              ),
              const SizedBox(height: 32),

              // --- TARJETA DEL FORMULARIO ---
              Card(
                elevation: 4,
                shadowColor: Colors.black12,
                color: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Crear Cuenta',
                        style: TextStyle(
                          fontSize: 22, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black87
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Completa el formulario para registrarte',
                        style: TextStyle(
                          fontSize: 14, 
                          color: Colors.grey[600]
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Campos
                      _buildLabel('Nombre completo'),
                      _buildTextField(hintText: 'Juan Pérez', icon: Icons.person_outline_rounded),
                      const SizedBox(height: 16),

                      _buildLabel('Correo electrónico'),
                      _buildTextField(hintText: 'admin@booksexchange.com', icon: Icons.email_outlined),
                      const SizedBox(height: 16),

                      _buildLabel('Organización (opcional)'),
                      _buildTextField(hintText: 'Mi Librería', icon: Icons.business_outlined),
                      const SizedBox(height: 16),

                      _buildLabel('Contraseña'),
                      _buildTextField(
                        hintText: '••••••••', 
                        icon: Icons.lock_outline_rounded,
                        isPassword: true
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                        child: Text(
                          'Mínimo 8 caracteres',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildLabel('Confirmar contraseña'),
                      _buildTextField(
                        hintText: '••••••••', 
                        icon: Icons.lock_outline_rounded,
                        isPassword: true
                      ),
                      const SizedBox(height: 24),

                      // Checkbox visual (estático)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_box_outline_blank, color: Colors.grey[400], size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4),
                                children: [
                                  const TextSpan(text: 'Acepto los '),
                                  TextSpan(
                                    text: 'términos y condiciones',
                                    style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(text: ' y la '),
                                  TextSpan(
                                    text: 'política de privacidad',
                                    style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // --- BOTÓN AZUL ---
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF64B5F6), // Azul del botón
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Crear Cuenta',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                      
                      // Separador
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Divider(color: Colors.grey[300], thickness: 1),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('o', style: TextStyle(color: Colors.grey[500])),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Link Iniciar Sesión
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿Ya tienes una cuenta? ',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Inicia sesión',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Footer Secure Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.lock_outline_rounded, color: Colors.blue[400]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Registro seguro',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
                          ),
                          const SizedBox(height: 2),
                          Text('Tus datos están protegidos con encriptación',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper para estilizar los Inputs
  Widget _buildTextField({
    required String hintText, 
    required IconData icon, 
    bool isPassword = false
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA), 
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
          suffixIcon: isPassword 
            ? Icon(Icons.visibility_off_outlined, color: Colors.grey[400], size: 20) 
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600, 
          fontSize: 14, 
          color: Colors.grey[800]
        ),
      ),
    );
  }
}