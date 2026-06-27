import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/dashboard_widgets.dart';
import 'experience_list_screen.dart';
import 'gastronomic_route_screen.dart';
import 'welcome_screen.dart';

class TouristHomeScreen extends StatelessWidget {
  const TouristHomeScreen({super.key});

  static const routeName = '/tourist-home';

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
                  title: 'Panel turista',
                  subtitle:
                      'Explora rutas, guarda experiencias y descubre recomendaciones gastronómicas.',
                  icon: Icons.travel_explore,
                ),
                const SizedBox(height: 26),
                const DashboardSectionTitle(title: 'Explorar'),
                const SizedBox(height: 16),
                ResponsiveDashboardGrid(
                  children: [
                    DashboardActionCard(
                      icon: Icons.restaurant,
                      title: 'Explorar rutas',
                      subtitle: 'Encuentra experiencias gastronómicas.',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ExperienceListScreen.routeName,
                        );
                      },
                    ),
                    DashboardActionCard(
                      icon: Icons.bookmark,
                      title: 'Guardar experiencias',
                      subtitle: 'Organiza tus favoritos para visitar después.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.route,
                      title: 'Ruta gastronómica',
                      subtitle: 'Genera una ruta base para tu viaje.',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          GastronomicRouteScreen.routeName,
                        );
                      },
                    ),
                    DashboardActionCard(
                      icon: Icons.auto_awesome,
                      title: 'Recomendaciones gastronómicas',
                      subtitle: 'Recibe sugerencias según tus intereses.',
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
