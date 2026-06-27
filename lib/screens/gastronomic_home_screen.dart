import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/dashboard_widgets.dart';
import 'welcome_screen.dart';

class GastronomicHomeScreen extends StatelessWidget {
  const GastronomicHomeScreen({super.key});

  static const routeName = '/gastronomic-home';

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
                  title: 'Panel gastronómico',
                  subtitle:
                      'Gestiona tu negocio gastronómico, experiencias y oportunidades con turistas.',
                  icon: Icons.restaurant_menu,
                ),
                const SizedBox(height: 26),
                const DashboardSectionTitle(title: 'Gestión del negocio'),
                const SizedBox(height: 16),
                ResponsiveDashboardGrid(
                  children: [
                    DashboardActionCard(
                      icon: Icons.store,
                      title: 'Gestionar negocio gastronómico',
                      subtitle: 'Actualiza datos, ciudad, categoría y oferta.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.add_business,
                      title: 'Crear experiencias',
                      subtitle:
                          'Convierte tu comida en una experiencia turística.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.groups,
                      title: 'Ver reservas o interesados',
                      subtitle:
                          'Consulta turistas interesados en tus propuestas.',
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
