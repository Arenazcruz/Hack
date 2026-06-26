import 'package:flutter/material.dart';

import '../widgets/empty_state.dart';
import '../widgets/screen_shell.dart';

class GastronomicRouteScreen extends StatelessWidget {
  const GastronomicRouteScreen({super.key});

  static const routeName = '/routes/gastronomic';

  @override
  Widget build(BuildContext context) {
    return const ScreenShell(
      title: 'Ruta gastronomica',
      child: EmptyState(
        title: 'Generar ruta gastronomica',
        subtitle: 'Aqui se integrara Gemini API para rutas turisticas.',
      ),
    );
  }
}
