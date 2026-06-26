import 'package:flutter/material.dart';

import '../services/auth_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return _PlaceholderRoleHome(
      title: 'Dashboard gastronómico',
      subtitle: 'Gestiona tu negocio gastronómico en SUMAQ IA.',
      onSignOut: () => _signOut(context),
    );
  }
}

class _PlaceholderRoleHome extends StatelessWidget {
  const _PlaceholderRoleHome({
    required this.title,
    required this.subtitle,
    required this.onSignOut,
  });

  final String title;
  final String subtitle;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      appBar: AppBar(
        title: const Text('SUMAQ IA'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF211B17),
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF6F625A), fontSize: 16),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onSignOut,
                child: const Text('Cerrar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
