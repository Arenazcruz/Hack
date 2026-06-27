import 'package:flutter/material.dart';

import '../models/entrepreneur_profile.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/entrepreneur_service.dart';
import '../services/firestore_service.dart';
import '../utils/display_labels.dart';
import 'entrepreneur_products_screen.dart';
import 'entrepreneur_profile_screen.dart';
import 'welcome_screen.dart';

class EntrepreneurHomeScreen extends StatelessWidget {
  const EntrepreneurHomeScreen({super.key});

  static const routeName = '/entrepreneur-home';
  static const _primaryColor = Color(0xFFE8671B);
  static const _backgroundColor = Color(0xFFFFF8F4);
  static const _textColor = Color(0xFF211B17);
  static const _mutedTextColor = Color(0xFF6F625A);

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

  Future<UserProfile?> _loadUserProfile() async {
    final user = AuthService().currentUser;
    if (user == null) {
      return null;
    }

    return FirestoreService().getUserProfile(user.uid);
  }

  bool _canAccess(String role) {
    return {
      'emprendedor',
      'gastronomico',
      'administrador',
      'entrepreneur',
      'gastronomic',
      'admin',
    }.contains(role.trim().toLowerCase());
  }

  void _openProfile(BuildContext context) {
    Navigator.pushNamed(context, EntrepreneurProfileScreen.routeName);
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _loadUserProfile(),
      builder: (context, snapshot) {
        final firebaseUser = AuthService().currentUser;
        final userProfile = snapshot.data;
        final role = userProfile?.role ?? '';

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: _backgroundColor,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (firebaseUser == null || userProfile == null) {
          return _PermissionScaffold(
            onSignOut: () => _signOut(context),
            message: 'Debes iniciar sesión para acceder a este módulo.',
          );
        }

        if (!_canAccess(role)) {
          return _PermissionScaffold(
            onSignOut: () => _signOut(context),
            message: 'No tienes permisos para acceder a este módulo.',
          );
        }

        return Scaffold(
          backgroundColor: _backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                _TopHeader(onSignOut: () => _signOut(context)),
                Expanded(
                  child: StreamBuilder<EntrepreneurProfile?>(
                    stream: EntrepreneurService().streamMyEntrepreneurProfile(),
                    builder: (context, profileSnapshot) {
                      if (profileSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final profile = profileSnapshot.data;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1180),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _WelcomeSection(
                                    name: userProfile.name.isEmpty
                                        ? firebaseUser.email ?? 'emprendedor'
                                        : userProfile.name,
                                  ),
                                  const SizedBox(height: 24),
                                  if (profile == null)
                                    _EmptyEntrepreneurCard(
                                      onRegister: () => _openProfile(context),
                                    )
                                  else
                                    _EntrepreneurOverview(
                                      user: userProfile,
                                      profile: profile,
                                      onEdit: () => _openProfile(context),
                                    ),
                                  const SizedBox(height: 26),
                                  _MetricsGrid(profile: profile),
                                  const SizedBox(height: 26),
                                  _QuickActions(
                                    hasProfile: profile != null,
                                    onEdit: () => _openProfile(context),
                                    onProducts: () => Navigator.pushNamed(
                                      context,
                                      EntrepreneurProductsScreen.routeName,
                                    ),
                                    onExperiences: () => _snack(
                                      context,
                                      'Esta sección se implementará en la siguiente fase.',
                                    ),
                                    onPublicView: () => _snack(
                                      context,
                                      'La vista pública se implementará próximamente.',
                                    ),
                                    onAi: () => _snack(
                                      context,
                                      'Esta función se integrará próximamente con Gemini.',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 720;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(color: Color(0xFFF4E6DC))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: isCompact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _HeaderTitle(),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: onSignOut,
                        icon: const Icon(Icons.logout),
                        label: const Text('Cerrar sesión'),
                        style: FilledButton.styleFrom(
                          backgroundColor: EntrepreneurHomeScreen._primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const _HeaderTitle(),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: onSignOut,
                        icon: const Icon(Icons.logout),
                        label: const Text('Cerrar sesión'),
                        style: FilledButton.styleFrom(
                          backgroundColor: EntrepreneurHomeScreen._primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Panel del emprendedor',
          style: TextStyle(
            color: EntrepreneurHomeScreen._textColor,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Gestiona tu emprendimiento gastronómico desde SUMAQ IA.',
          style: TextStyle(
            color: EntrepreneurHomeScreen._mutedTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenido, $name',
            style: const TextStyle(
              color: EntrepreneurHomeScreen._textColor,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Aquí puedes revisar y actualizar la información de tu emprendimiento.',
            style: TextStyle(
              color: EntrepreneurHomeScreen._mutedTextColor,
              fontSize: 15,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyEntrepreneurCard extends StatelessWidget {
  const _EmptyEntrepreneurCard({required this.onRegister});

  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.storefront,
            color: EntrepreneurHomeScreen._primaryColor,
            size: 42,
          ),
          const SizedBox(height: 18),
          const Text(
            'Aún no registraste tu emprendimiento',
            style: TextStyle(
              color: EntrepreneurHomeScreen._textColor,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Completa los datos de tu emprendimiento para empezar a mostrarlo en SUMAQ IA.',
            style: TextStyle(
              color: EntrepreneurHomeScreen._mutedTextColor,
              fontSize: 15,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onRegister,
            icon: const Icon(Icons.edit),
            label: const Text('Registrar mi emprendimiento'),
            style: FilledButton.styleFrom(
              backgroundColor: EntrepreneurHomeScreen._primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              textStyle: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntrepreneurOverview extends StatelessWidget {
  const _EntrepreneurOverview({
    required this.user,
    required this.profile,
    required this.onEdit,
  });

  final UserProfile user;
  final EntrepreneurProfile profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 920;

    if (!isWide) {
      return Column(
        children: [
          _UserProfileCard(user: user),
          const SizedBox(height: 18),
          _BusinessCard(profile: profile, onEdit: onEdit),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 310, child: _UserProfileCard(user: user)),
        const SizedBox(width: 18),
        Expanded(
          child: _BusinessCard(profile: profile, onEdit: onEdit),
        ),
      ],
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  const _UserProfileCard({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final initial = user.name.trim().isEmpty ? 'S' : user.name.trim()[0];

    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: EntrepreneurHomeScreen._primaryColor,
            child: Text(
              initial.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              color: EntrepreneurHomeScreen._textColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(
              color: EntrepreneurHomeScreen._mutedTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _Badge(label: roleLabel(user.role)),
          const SizedBox(height: 10),
          const _Badge(label: 'Activo'),
        ],
      ),
    );
  }
}

class _BusinessCard extends StatelessWidget {
  const _BusinessCard({required this.profile, required this.onEdit});

  final EntrepreneurProfile profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BusinessImage(imageUrl: profile.imageUrl),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Badge(label: profile.category),
                    _Badge(label: profile.city),
                    _Badge(label: _statusLabel(profile.status)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  profile.businessName,
                  style: const TextStyle(
                    color: EntrepreneurHomeScreen._textColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  profile.description,
                  style: const TextStyle(
                    color: EntrepreneurHomeScreen._mutedTextColor,
                    fontSize: 15,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                _InfoLine(icon: Icons.location_on, text: profile.location),
                _InfoLine(icon: Icons.phone, text: profile.phone),
                if (_hasText(profile.socialUrl))
                  _InfoLine(
                    icon: Icons.alternate_email,
                    text: profile.socialUrl!,
                  ),
                if (_hasText(profile.website))
                  _InfoLine(icon: Icons.language, text: profile.website!),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar mi emprendimiento'),
                  style: FilledButton.styleFrom(
                    backgroundColor: EntrepreneurHomeScreen._primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BusinessImage extends StatelessWidget {
  const _BusinessImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (!_hasText(imageUrl)) {
      return Container(
        width: double.infinity,
        height: 220,
        color: const Color(0xFFFFEFE6),
        alignment: Alignment.center,
        child: const Text(
          'Sin imagen del emprendimiento',
          style: TextStyle(
            color: EntrepreneurHomeScreen._mutedTextColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Image.network(
        imageUrl!,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: double.infinity,
          height: 220,
          color: const Color(0xFFFFEFE6),
          alignment: Alignment.center,
          child: const Text(
            'No se pudo cargar la imagen',
            style: TextStyle(
              color: EntrepreneurHomeScreen._mutedTextColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.profile});

  final EntrepreneurProfile? profile;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      const _MetricCard(value: '0', label: 'Productos registrados'),
      const _MetricCard(value: '0', label: 'Experiencias creadas'),
      _MetricCard(
        value: profile == null ? 'No' : 'Sí',
        label: 'Perfil publicado',
      ),
      const _MetricCard(value: 'Próximamente', label: 'Contenido IA'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 680
            ? 1
            : constraints.maxWidth < 980
            ? 2
            : 4;
        const spacing = 16.0;
        final width = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final metric in metrics)
              SizedBox(width: width.toDouble(), child: metric),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: EntrepreneurHomeScreen._primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: EntrepreneurHomeScreen._mutedTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.hasProfile,
    required this.onEdit,
    required this.onProducts,
    required this.onExperiences,
    required this.onPublicView,
    required this.onAi,
  });

  final bool hasProfile;
  final VoidCallback onEdit;
  final VoidCallback onProducts;
  final VoidCallback onExperiences;
  final VoidCallback onPublicView;
  final VoidCallback onAi;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acciones rápidas',
          style: TextStyle(
            color: EntrepreneurHomeScreen._textColor,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth < 760 ? 1 : 2;
            const spacing = 16.0;
            final width = columns == 1
                ? constraints.maxWidth
                : (constraints.maxWidth - spacing) / 2;

            final actions = [
              _ActionCard(
                icon: Icons.edit,
                title: hasProfile
                    ? 'Editar mi emprendimiento'
                    : 'Registrar mi emprendimiento',
                onTap: onEdit,
              ),
              _ActionCard(
                icon: Icons.inventory_2,
                title: 'Productos y servicios',
                onTap: onProducts,
              ),
              _ActionCard(
                icon: Icons.restaurant_menu,
                title: 'Experiencias gastronómicas',
                onTap: onExperiences,
              ),
              _ActionCard(
                icon: Icons.visibility,
                title: 'Vista pública',
                onTap: onPublicView,
              ),
              _ActionCard(
                icon: Icons.auto_awesome,
                title: 'Contenido con IA',
                onTap: onAi,
              ),
            ];

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final action in actions)
                  SizedBox(width: width.toDouble(), child: action),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: _DashboardCard(
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEFE6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: EntrepreneurHomeScreen._primaryColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: EntrepreneurHomeScreen._textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: EntrepreneurHomeScreen._primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: EntrepreneurHomeScreen._primaryColor, size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: EntrepreneurHomeScreen._mutedTextColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFE6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFFFDEC6)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: EntrepreneurHomeScreen._primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.child,
    this.padding = const EdgeInsets.all(22),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF4E6DC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PermissionScaffold extends StatelessWidget {
  const _PermissionScaffold({required this.onSignOut, required this.message});

  final VoidCallback onSignOut;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EntrepreneurHomeScreen._backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _TopHeader(onSignOut: onSignOut),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: _DashboardCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          color: EntrepreneurHomeScreen._primaryColor,
                          size: 42,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: EntrepreneurHomeScreen._textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _statusLabel(String status) {
  switch (status.trim().toLowerCase()) {
    case 'active':
      return 'Activo';
    case 'inactive':
      return 'Inactivo';
    default:
      return status.isEmpty ? 'Activo' : status;
  }
}

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;
