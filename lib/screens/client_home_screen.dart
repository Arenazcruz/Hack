import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'experience_list_screen.dart';
import 'welcome_screen.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  static const routeName = '/client-home';

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
        content: Text('Este flujo se implementará en el siguiente paso.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      appBar: AppBar(
        title: const Text('SUMAQ IA'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        actions: [
          TextButton.icon(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bienvenido a SUMAQ IA',
                  style: TextStyle(
                    color: Color(0xFF211B17),
                    fontSize: 38,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Explora experiencias gastronómicas, descubre rutas locales y conecta con emprendedores bolivianos.',
                  style: TextStyle(
                    color: Color(0xFF6F625A),
                    fontSize: 18,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 760;
                    return Wrap(
                      spacing: 18,
                      runSpacing: 18,
                      children: [
                        _HomeActionCard(
                          width: isCompact
                              ? constraints.maxWidth
                              : (constraints.maxWidth - 36) / 3,
                          icon: Icons.restaurant,
                          title: 'Explorar experiencias',
                          subtitle: 'Descubre sabores y rutas locales.',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ExperienceListScreen.routeName,
                            );
                          },
                        ),
                        _HomeActionCard(
                          width: isCompact
                              ? constraints.maxWidth
                              : (constraints.maxWidth - 36) / 3,
                          icon: Icons.storefront,
                          title: 'Crear mi emprendimiento',
                          subtitle: 'Prepara tu perfil gastronómico.',
                          onTap: () => _showPendingMessage(context),
                        ),
                        _HomeActionCard(
                          width: isCompact
                              ? constraints.maxWidth
                              : (constraints.maxWidth - 36) / 3,
                          icon: Icons.route,
                          title: 'Ofrecer una ruta turística',
                          subtitle: 'Conecta experiencias en tu ciudad.',
                          onTap: () => _showPendingMessage(context),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeActionCard extends StatelessWidget {
  const _HomeActionCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final double width;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFF4E6DC)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEFE6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: const Color(0xFFE8671B), size: 28),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF211B17),
                  fontSize: 18,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF6F625A),
                  fontSize: 14,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
