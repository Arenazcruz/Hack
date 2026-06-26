import 'package:flutter/material.dart';

import '../widgets/empty_state.dart';
import '../widgets/screen_shell.dart';

class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({super.key});

  static const routeName = '/experiences/detail';

  @override
  Widget build(BuildContext context) {
    return const ScreenShell(
      title: 'Detalle de experiencia',
      child: EmptyState(
        title: 'Detalle de experiencia',
        subtitle: 'Aqui se mostrara la experiencia seleccionada.',
      ),
    );
  }
}
