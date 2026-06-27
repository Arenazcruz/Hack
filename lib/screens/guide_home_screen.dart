import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/dashboard_widgets.dart';
import 'welcome_screen.dart';

class GuideHomeScreen extends StatelessWidget {
  const GuideHomeScreen({super.key});

  static const routeName = '/guide-home';

  Future<void> _signOut(BuildContext context) async {
    await AuthService().signOut();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        WelcomeScreen.routeName,
        (_) => false,
      );
    }
  }

  void _showPendingMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Esta funcionalidad se implementará después'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SumaqDashboardScaffold(
      title: 'SUMAQ IA',
      onSignOut: () => _signOut(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DashboardHero(
                  title: 'Panel guía turístico',
                  subtitle:
                      'Crea rutas turísticas y conecta experiencias gastronómicas guiadas.',
                  icon: Icons.map,
                ),
                const SizedBox(height: 26),
                const DashboardSectionTitle(title: 'Herramientas de guía'),
                const SizedBox(height: 16),
                ResponsiveDashboardGrid(
                  children: [
                    DashboardActionCard(
                      icon: Icons.route,
                      title: 'Crear rutas turísticas',
                      subtitle:
                          'Diseña recorridos con sabores y cultura local.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.explore,
                      title: 'Experiencias guiadas',
                      subtitle: 'Organiza servicios para visitantes.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.auto_awesome,
                      title: 'Recomendaciones IA',
                      subtitle: 'Mejora tus rutas con ayuda inteligente.',
                      onTap: () => _showPendingMessage(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
