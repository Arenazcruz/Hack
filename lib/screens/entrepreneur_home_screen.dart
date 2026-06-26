import 'package:flutter/material.dart';

import 'create_experience_screen.dart';
import 'entrepreneur_profile_screen.dart';

class EntrepreneurHomeScreen extends StatelessWidget {
  const EntrepreneurHomeScreen({super.key});

  static const routeName = '/entrepreneur-home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel emprendedor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.storefront),
            title: const Text('Perfil de emprendedor'),
            subtitle: const Text('Completa la informacion de tu negocio.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, EntrepreneurProfileScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add_business),
            title: const Text('Crear experiencia gastronomica'),
            subtitle: const Text('Publica una propuesta turistica culinaria.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, CreateExperienceScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
