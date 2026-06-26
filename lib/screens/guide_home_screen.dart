import 'package:flutter/material.dart';

import '../services/auth_service.dart';
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
              const Text(
                'Dashboard de guías',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF211B17),
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Gestiona rutas y servicios turísticos en SUMAQ IA.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF6F625A), fontSize: 16),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => _signOut(context),
                child: const Text('Cerrar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
