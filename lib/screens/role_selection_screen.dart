import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_role.dart';
import '../models/user_profile.dart';
import '../providers/app_state_provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'entrepreneur_home_screen.dart';
import 'login_screen.dart';
import 'tourist_home_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  static const routeName = '/roles';

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();

  String? _loadingRole;

  Future<void> _selectRole(String role) async {
    final user = _authService.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para elegir un rol.'),
        ),
      );
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      return;
    }

    setState(() => _loadingRole = role);

    try {
      final existingProfile = await _firestoreService.getUserProfile(user.uid);
      final profile =
          existingProfile?.copyWith(role: role) ??
          UserProfile(
            uid: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            role: role,
            city: '',
            createdAt: DateTime.now(),
          );

      await _firestoreService.createUserProfile(profile);

      if (!mounted) {
        return;
      }

      if (role == 'entrepreneur') {
        context.read<AppStateProvider>().selectRole(AppRole.entrepreneur);
        Navigator.pushReplacementNamed(
          context,
          EntrepreneurHomeScreen.routeName,
        );
      } else {
        context.read<AppStateProvider>().selectRole(AppRole.tourist);
        Navigator.pushReplacementNamed(context, TouristHomeScreen.routeName);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() => _loadingRole = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF6),
      appBar: AppBar(
        title: const Text('Selecciona tu rol'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.12),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Completa tu perfil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF211B17),
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Elige cómo usarás SUMAQ IA.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6F625A),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                _RoleCard(
                  title: 'Emprendedor',
                  subtitle: 'Publica experiencias culinarias para turistas.',
                  icon: Icons.restaurant_menu,
                  isLoading: _loadingRole == 'entrepreneur',
                  onTap: _loadingRole == null
                      ? () => _selectRole('entrepreneur')
                      : null,
                ),
                const SizedBox(height: 14),
                _RoleCard(
                  title: 'Turista',
                  subtitle:
                      'Descubre experiencias y rutas gastronómicas en Bolivia.',
                  icon: Icons.travel_explore,
                  isLoading: _loadingRole == 'tourist',
                  onTap: _loadingRole == null
                      ? () => _selectRole('tourist')
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isLoading,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(20),
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
        child: Row(
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF211B17),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
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
            const SizedBox(width: 12),
            if (isLoading)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4),
              )
            else
              const Icon(Icons.chevron_right, color: Color(0xFFE8671B)),
          ],
        ),
      ),
    );
  }
}
