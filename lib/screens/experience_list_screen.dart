import 'package:flutter/material.dart';

import 'experience_detail_screen.dart';

class ExperienceListScreen extends StatelessWidget {
  const ExperienceListScreen({super.key});

  static const routeName = '/experiences';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experiencias')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 1,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.local_dining),
              title: const Text('Experiencia de ejemplo'),
              subtitle: const Text('Placeholder para futuras publicaciones.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, ExperienceDetailScreen.routeName);
              },
            ),
          );
        },
      ),
    );
  }
}
