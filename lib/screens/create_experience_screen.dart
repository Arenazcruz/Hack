import 'package:flutter/material.dart';

import '../widgets/empty_state.dart';
import '../widgets/screen_shell.dart';

class CreateExperienceScreen extends StatelessWidget {
  const CreateExperienceScreen({super.key});

  static const routeName = '/experiences/create';

  @override
  Widget build(BuildContext context) {
    return const ScreenShell(
      title: 'Crear experiencia',
      child: EmptyState(
        title: 'Nueva experiencia gastronomica',
        subtitle: 'Aqui se conectaran Firestore, Storage y Gemini.',
      ),
    );
  }
}
