import 'package:flutter/material.dart';

import '../widgets/empty_state.dart';
import '../widgets/screen_shell.dart';
import 'register_screen.dart';
import 'role_selection_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      title: 'Sumaq Ruta AI',
      child: Column(
        children: [
          const Expanded(
            child: EmptyState(
              title: 'Login',
              subtitle: 'Pantalla base para Firebase Auth.',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoleSelectionScreen.routeName);
                  },
                  child: const Text('Continuar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterScreen.routeName);
                  },
                  child: const Text('Crear cuenta'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
