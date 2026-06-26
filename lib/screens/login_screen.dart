import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/role_redirect_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'register_screen.dart';
import 'welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';
  static const _primaryColor = Color(0xFFE8671B);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final _firestoreService = FirestoreService();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await _authService.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      final user = credential.user;

      if (user == null) {
        throw const AuthServiceException(
          'Ocurrió un error. Intenta nuevamente.',
        );
      }

      final profile = await _firestoreService.getUserProfile(user.uid);

      if (!mounted) {
        return;
      }

      if (profile == null || profile.role.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se encontró el perfil del usuario.'),
          ),
        );
        return;
      }

      RoleRedirectService.redirectByRole(context, profile);
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
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: isWide
                      ? Row(
                          children: [
                            const Expanded(child: _BrandPanel()),
                            const SizedBox(width: 28),
                            Expanded(child: _LoginCard(form: _buildForm())),
                          ],
                        )
                      : _LoginCard(form: _buildForm()),
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 12,
              child: IconButton(
                tooltip: 'Volver',
                onPressed: _isLoading ? null : _goToWelcome,
                icon: const Icon(Icons.arrow_back),
                color: const Color(0xFF3A2B22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _emailController,
            label: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateRequiredEmail,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            label: 'Contraseña',
            obscureText: true,
            textInputAction: TextInputAction.done,
            validator: _validateRequiredPassword,
          ),
          const SizedBox(height: 22),
          PrimaryButton(
            label: 'Ingresar',
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
                      RegisterScreen.routeName,
                    );
                  },
            child: const Text('¿No tienes cuenta? Crear cuenta'),
          ),
        ],
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 560),
      padding: const EdgeInsets.all(38),
      decoration: BoxDecoration(
        color: LoginScreen._primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: LoginScreen._primaryColor.withValues(alpha: 0.24),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: LoginScreen._primaryColor,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Bienvenido a SUMAQ IA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              height: 1.08,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Descubre experiencias gastronómicas, turismo local e inteligencia artificial en un solo lugar.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 18,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({required this.form});

  final Widget form;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF4E6DC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _LoginLogo(),
          const SizedBox(height: 24),
          const Text(
            'Bienvenido de nuevo',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF211B17),
              fontSize: 30,
              height: 1.1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Ingresa para continuar explorando experiencias gastronómicas inteligentes.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6F625A),
              fontSize: 15,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 26),
          form,
        ],
      ),
    );
  }
}

class _LoginLogo extends StatelessWidget {
  const _LoginLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: LoginScreen._primaryColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: LoginScreen._primaryColor.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'S',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'SUMAQ IA',
          style: TextStyle(
            color: Color(0xFF211B17),
            fontSize: 21,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

String? _validateRequiredEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) {
    return 'El correo es obligatorio.';
  }

  return null;
}

String? _validateRequiredPassword(String? value) {
  if ((value ?? '').isEmpty) {
    return 'La contraseña es obligatoria.';
  }

  return null;
}
