import 'package:flutter/material.dart';

import '../widgets/empty_state.dart';
import '../widgets/screen_shell.dart';
import 'role_selection_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      title: 'Registro',
      child: Column(
        children: [
          const Expanded(
            child: EmptyState(
              title: 'Crear cuenta',
              subtitle: 'Pantalla base para registro con Firebase Auth.',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoleSelectionScreen.routeName);
                },
                child: const Text('Seleccionar rol'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
