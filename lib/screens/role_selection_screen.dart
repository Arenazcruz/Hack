import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_role.dart';
import '../providers/app_state_provider.dart';
import 'entrepreneur_home_screen.dart';
import 'tourist_home_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  static const routeName = '/roles';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona tu rol')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _RoleCard(
            title: 'Emprendedor gastronomico',
            subtitle: 'Publica experiencias culinarias para turistas.',
            icon: Icons.restaurant_menu,
            onTap: () {
              context.read<AppStateProvider>().selectRole(AppRole.entrepreneur);
              Navigator.pushReplacementNamed(
                context,
                EntrepreneurHomeScreen.routeName,
              );
            },
          ),
          const SizedBox(height: 12),
          _RoleCard(
            title: 'Turista',
            subtitle: 'Descubre experiencias y rutas gastronomicas en Bolivia.',
            icon: Icons.travel_explore,
            onTap: () {
              context.read<AppStateProvider>().selectRole(AppRole.tourist);
              Navigator.pushReplacementNamed(
                context,
                TouristHomeScreen.routeName,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
