import 'package:booksy_app/features/auth/register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// TODO: Asegúrate de importar tu DashboardScreen aquí arriba
// import 'package:booksy_app/features/dashboard/view/dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;

  void _goToLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _organizationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF5D9CFF);
    const backgroundColor = Color(0xFFF4F8FF);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        _goToLogin();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              } else if (state is RegisterSuccess) {
                // Navegamos al Dashboard si el registro es exitoso
                /* Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
                */
              }
            },
            builder: (context, state) {
              final isLoading = state is RegisterLoading;

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // --- CABECERA (Logo y Títulos) ---
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Booksy',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Formulario de registro',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),

                      // --- TARJETA PRINCIPAL (Formulario) ---
                      Container(
                        padding: const EdgeInsets.all(24),
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Crear Cuenta',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Completa el formulario para registrarte',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Campo: Nombre
                              _buildLabel('Nombre completo'),
                              _buildTextField(
                                controller: _nameController,
                                hintText: 'Juan Pérez',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 16),

                              // Campo: Correo
                              _buildLabel('Correo electrónico'),
                              _buildTextField(
                                controller: _emailController,
                                hintText: 'admin@booksexchange.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),

                              // Campo: Organización
                              _buildLabel('Organización (opcional)'),
                              _buildTextField(
                                controller: _organizationController,
                                hintText: 'Mi Librería',
                                icon: Icons.business_outlined,
                              ),
                              const SizedBox(height: 16),

                              // Campo: Contraseña
                              _buildLabel('Contraseña'),
                              _buildTextField(
                                controller: _passwordController,
                                hintText: '••••••••',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                obscureText: _obscurePassword,
                                onTogglePassword: () {
                                  setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  );
                                },
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Mínimo 8 caracteres',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Campo: Confirmar Contraseña
                              _buildLabel('Confirmar contraseña'),
                              _buildTextField(
                                controller: _confirmPasswordController,
                                hintText: '••••••••',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                obscureText: _obscureConfirmPassword,
                                onTogglePassword: () {
                                  setState(
                                    () => _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                                  );
                                },
                              ),
                              const SizedBox(height: 24),

                              // Checkbox de Términos
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: _acceptedTerms,
                                      activeColor: primaryBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      onChanged: (value) {
                                        setState(
                                          () => _acceptedTerms = value ?? false,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                          height: 1.5,
                                        ),
                                        children: [
                                          TextSpan(text: 'Acepto los '),
                                          TextSpan(
                                            text: 'términos y condiciones',
                                            style: TextStyle(
                                              color: primaryBlue,
                                            ),
                                          ),
                                          TextSpan(text: ' y la '),
                                          TextSpan(
                                            text: 'política de privacidad',
                                            style: TextStyle(
                                              color: primaryBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Botón de Registro
                              SizedBox(
                                height: 50,
                                child: FilledButton(
                                  onPressed: _acceptedTerms && !isLoading
                                      ? () {
                                          context.read<RegisterBloc>().add(
                                            RegisterSubmitted(
                                              nombre: _nameController.text,
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              passwordConfirmation:
                                                  _confirmPasswordController
                                                      .text,
                                              organizacion:
                                                  _organizationController.text,
                                            ),
                                          );
                                        }
                                      : null,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: primaryBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : const Text(
                                          'Crear Cuenta',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Separador
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: Colors.grey[300]),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      'o',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.grey[300]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              Center(
                                child: TextButton(
                                  onPressed: _goToLogin,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                  ),
                                  child: const Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '¿Ya tienes una cuenta? ',
                                        ),
                                        TextSpan(
                                          text: 'Inicia sesión',
                                          style: TextStyle(
                                            color: Color(0xFF5D9CFF),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- TARJETA INFERIOR (Registro Seguro) ---
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.lock_outline,
                                color: primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Registro seguro',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Tus datos están protegidos con encriptación',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
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
              );
            },
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES PARA LIMPIAR EL CÓDIGO ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey.shade500,
                  size: 20,
                ),
                onPressed: onTogglePassword,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF9FAFC),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5D9CFF), width: 1.5),
        ),
      ),
    );
  }
}
