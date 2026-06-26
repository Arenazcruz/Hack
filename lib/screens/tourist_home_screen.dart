import 'package:flutter/material.dart';

import 'experience_list_screen.dart';
import 'gastronomic_route_screen.dart';

class TouristHomeScreen extends StatelessWidget {
  const TouristHomeScreen({super.key});

  static const routeName = '/tourist';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explorar Bolivia')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.restaurant),
            title: const Text('Experiencias gastronomicas'),
            subtitle: const Text('Lista base para turistas.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, ExperienceListScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.route),
            title: const Text('Generar ruta gastronomica'),
            subtitle: const Text('Pantalla base para Gemini API.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, GastronomicRouteScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
