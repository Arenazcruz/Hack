import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/dashboard_widgets.dart';
import 'create_experience_screen.dart';
import 'entrepreneur_profile_screen.dart';
import 'welcome_screen.dart';

class EntrepreneurHomeScreen extends StatelessWidget {
  const EntrepreneurHomeScreen({super.key});

  static const routeName = '/entrepreneur-home';

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
                  title: 'Panel emprendedor',
                  subtitle:
                      'Gestiona tu emprendimiento gastronómico y prepara experiencias para turistas.',
                  icon: Icons.storefront,
                ),
                const SizedBox(height: 26),
                const DashboardSectionTitle(title: 'Herramientas'),
                const SizedBox(height: 16),
                ResponsiveDashboardGrid(
                  children: [
                    DashboardActionCard(
                      icon: Icons.storefront,
                      title: 'Gestionar mi emprendimiento',
                      subtitle: 'Completa datos y presentación del negocio.',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          EntrepreneurProfileScreen.routeName,
                        );
                      },
                    ),
                    DashboardActionCard(
                      icon: Icons.add_business,
                      title: 'Crear experiencia',
                      subtitle: 'Publica una propuesta turística culinaria.',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          CreateExperienceScreen.routeName,
                        );
                      },
                    ),
                    DashboardActionCard(
                      icon: Icons.auto_awesome,
                      title: 'Crear historia con IA',
                      subtitle: 'Mejora la narrativa de tu emprendimiento.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.campaign,
                      title: 'Publicaciones para redes',
                      subtitle: 'Prepara contenido promocional.',
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
