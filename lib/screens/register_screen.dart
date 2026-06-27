import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_page_layout.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'client_home_screen.dart';
import 'login_screen.dart';
import 'welcome_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  final _firestoreService = FirestoreService();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await _authService.registerWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      final user = credential.user;

      if (user == null) {
        throw const AuthServiceException(
          'Ocurrió un error. Intenta nuevamente.',
        );
      }

      await user.updateDisplayName(_nameController.text.trim());

      final profile = UserProfile(
        uid: user.uid,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: 'client',
        city: _cityController.text.trim(),
        createdAt: DateTime.now(),
      );

      await _firestoreService.createUserProfile(profile);

      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(context, ClientHomeScreen.routeName);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _goToWelcome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      WelcomeScreen.routeName,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      visualTitle: 'Crea tu cuenta en SUMAQ IA',
      visualSubtitle:
          'Descubre experiencias gastronómicas, turismo local e inteligencia artificial en un solo lugar.',
      child: AuthCard(
        title: 'Crear cuenta',
        subtitle:
            'Únete a SUMAQ IA y descubre experiencias gastronómicas, turismo local e inteligencia artificial.',
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Nombre completo',
                textInputAction: TextInputAction.next,
                validator: _validateRequiredName,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                label: 'Correo electrónico',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _cityController,
                label: 'Ciudad',
                textInputAction: TextInputAction.next,
                validator: _validateRequiredCity,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Contraseña',
                obscureText: true,
                textInputAction: TextInputAction.next,
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirmar contraseña',
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) => _validatePasswordConfirmation(
                  value,
                  _passwordController.text,
                ),
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                label: 'Crear cuenta',
                isLoading: _isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.pushReplacementNamed(
                          context,
                          LoginScreen.routeName,
                        );
                      },
                child: const Text('¿Ya tienes cuenta? Inicia sesión'),
              ),
              TextButton(
                onPressed: _isLoading ? null : _goToWelcome,
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? _validateRequiredName(String? value) {
  if ((value ?? '').trim().isEmpty) {
    return 'El nombre es obligatorio.';
  }
  return null;
}

String? _validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) {
    return 'El correo es obligatorio.';
  }
  if (!email.contains('@') || !email.contains('.')) {
    return 'Ingresa un correo válido.';
  }
  return null;
}

String? _validateRequiredCity(String? value) {
  if ((value ?? '').trim().isEmpty) {
    return 'La ciudad es obligatoria.';
  }
  return null;
}

String? _validatePassword(String? value) {
  final password = value ?? '';
  if (password.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres.';
  }
  return null;
}

String? _validatePasswordConfirmation(String? value, String password) {
  if ((value ?? '') != password) {
    return 'Las contraseñas no coinciden.';
  }
  return null;
}
