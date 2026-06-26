import 'package:flutter/material.dart';

import '../widgets/empty_state.dart';
import '../widgets/screen_shell.dart';

class EntrepreneurProfileScreen extends StatelessWidget {
  const EntrepreneurProfileScreen({super.key});

  static const routeName = '/entrepreneur/profile';

  @override
  Widget build(BuildContext context) {
    return const ScreenShell(
      title: 'Perfil emprendedor',
      child: EmptyState(
        title: 'Perfil de emprendedor',
        subtitle: 'Aqui se configurara el negocio gastronomico.',
      ),
    );
  }
}
