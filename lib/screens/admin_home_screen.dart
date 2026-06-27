import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/dashboard_widgets.dart';
import 'welcome_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  static const routeName = '/admin-home';

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
                  title: 'Panel administrador',
                  subtitle:
                      'Gestión general de usuarios, emprendimientos, rutas y experiencias.',
                  icon: Icons.admin_panel_settings,
                ),
                const SizedBox(height: 26),
                const DashboardSectionTitle(title: 'Módulos de administración'),
                const SizedBox(height: 16),
                ResponsiveDashboardGrid(
                  children: [
                    DashboardActionCard(
                      icon: Icons.people,
                      title: 'Usuarios',
                      subtitle: 'Revisar perfiles y roles registrados.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.storefront,
                      title: 'Emprendimientos',
                      subtitle: 'Administrar negocios gastronómicos.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.restaurant,
                      title: 'Experiencias',
                      subtitle: 'Supervisar propuestas gastronómicas.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.route,
                      title: 'Rutas turísticas',
                      subtitle: 'Gestionar recorridos y servicios.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.auto_awesome,
                      title: 'Contenido IA',
                      subtitle: 'Monitorear generación de contenido.',
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
