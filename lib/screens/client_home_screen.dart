import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'experience_list_screen.dart';
import 'welcome_screen.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  static const routeName = '/client-home';
  static const _primaryColor = Color(0xFFE8671B);
  static const _backgroundColor = Color(0xFFF8FAFC);
  static const _textColor = Color(0xFF0F172A);
  static const _mutedColor = Color(0xFF64748B);

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
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _ClientNavbar(onSignOut: () => _signOut(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1240),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _WelcomeCard(
                            onExplore: () {
                              Navigator.pushNamed(
                                context,
                                ExperienceListScreen.routeName,
                              );
                            },
                            onCreateBusiness: () =>
                                _showPendingMessage(context),
                            onOfferRoute: () => _showPendingMessage(context),
                          ),
                          const SizedBox(height: 26),
                          const _KpiGrid(),
                          const SizedBox(height: 30),
                          _QuickActionsSection(
                            onExplore: () {
                              Navigator.pushNamed(
                                context,
                                ExperienceListScreen.routeName,
                              );
                            },
                            onPending: () => _showPendingMessage(context),
                          ),
                          const SizedBox(height: 30),
                          const _RecentActivitySection(),
                        ],
                      ),
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

class _ClientNavbar extends StatelessWidget {
  const _ClientNavbar({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 820;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        border: const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: isCompact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const _NavbarBrand(),
                          const Spacer(),
                          _OrangeButton(
                            label: 'Cerrar sesión',
                            onPressed: onSignOut,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _NavPill(label: 'Dashboard', active: true),
                            SizedBox(width: 8),
                            _NavPill(label: 'Explorar'),
                            SizedBox(width: 8),
                            _NavPill(label: 'IA'),
                            SizedBox(width: 8),
                            _NavPill(label: 'Perfil'),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const _NavbarBrand(),
                      const Spacer(),
                      const _NavPill(label: 'Dashboard', active: true),
                      const SizedBox(width: 8),
                      const _NavPill(label: 'Explorar'),
                      const SizedBox(width: 8),
                      const _NavPill(label: 'IA'),
                      const SizedBox(width: 8),
                      const _NavPill(label: 'Perfil'),
                      const SizedBox(width: 14),
                      _OrangeButton(
                        label: 'Cerrar sesión',
                        onPressed: onSignOut,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _NavbarBrand extends StatelessWidget {
  const _NavbarBrand();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFB923C), ClientHomeScreen._primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: ClientHomeScreen._primaryColor.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'S',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SUMAQ IA',
              style: TextStyle(
                color: ClientHomeScreen._textColor,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Panel Cliente',
              style: TextStyle(
                color: ClientHomeScreen._primaryColor,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NavPill extends StatelessWidget {
  const _NavPill({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 42),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? const Color(0xFFFFEDD5) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: active ? const Color(0xFFFB923C) : const Color(0xFFFED7AA),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active
              ? ClientHomeScreen._primaryColor
              : const Color(0xFF92400E),
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({
    required this.onExplore,
    required this.onCreateBusiness,
    required this.onOfferRoute,
  });

  final VoidCallback onExplore;
  final VoidCallback onCreateBusiness;
  final VoidCallback onOfferRoute;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 920;

    return _ContentCard(
      padding: EdgeInsets.zero,
      child: isWide
          ? Row(
              children: [
                Expanded(
                  flex: 8,
                  child: _WelcomeCopy(
                    onExplore: onExplore,
                    onCreateBusiness: onCreateBusiness,
                    onOfferRoute: onOfferRoute,
                  ),
                ),
                const Expanded(flex: 4, child: _ImpactPanel()),
              ],
            )
          : Column(
              children: [
                _WelcomeCopy(
                  onExplore: onExplore,
                  onCreateBusiness: onCreateBusiness,
                  onOfferRoute: onOfferRoute,
                ),
                const _ImpactPanel(),
              ],
            ),
    );
  }
}

class _WelcomeCopy extends StatelessWidget {
  const _WelcomeCopy({
    required this.onExplore,
    required this.onCreateBusiness,
    required this.onOfferRoute,
  });

  final VoidCallback onExplore;
  final VoidCallback onCreateBusiness;
  final VoidCallback onOfferRoute;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFFFEDD5)),
            ),
            child: const Text(
              'Panel del cliente',
              style: TextStyle(
                color: ClientHomeScreen._primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Hola, bienvenido a SUMAQ IA',
            style: TextStyle(
              color: ClientHomeScreen._textColor,
              fontSize: 42,
              height: 1.08,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Explora experiencias gastronómicas, descubre rutas locales y conecta con emprendedores bolivianos.',
            style: TextStyle(
              color: ClientHomeScreen._mutedColor,
              fontSize: 17,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _OrangeButton(label: 'Explorar ahora', onPressed: onExplore),
              _OutlineOrangeButton(
                label: 'Crear mi emprendimiento',
                onPressed: onCreateBusiness,
              ),
              _OutlineOrangeButton(
                label: 'Ofrecer ruta turística',
                onPressed: onOfferRoute,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImpactPanel extends StatelessWidget {
  const _ImpactPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 280),
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFB923C), ClientHomeScreen._primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tu actividad',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '0 experiencias',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              'Tu historial se activará cuando empieces a explorar experiencias gastronómicas.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 680
            ? 1
            : constraints.maxWidth < 980
            ? 2
            : 4;
        const spacing = 18.0;
        final width = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children:
              const [
                    _KpiCard(label: 'Experiencias vistas', value: '0'),
                    _KpiCard(label: 'Rutas guardadas', value: '0'),
                    _KpiCard(label: 'Recomendaciones IA', value: '0'),
                    _KpiCard(label: 'Emprendimientos seguidos', value: '0'),
                  ]
                  .map((card) => SizedBox(width: width.toDouble(), child: card))
                  .toList(),
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: ClientHomeScreen._textColor,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection({
    required this.onExplore,
    required this.onPending,
  });

  final VoidCallback onExplore;
  final VoidCallback onPending;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          title: 'Acciones rápidas',
          subtitle: 'Elige una acción para continuar en SUMAQ IA.',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth < 820 ? 1 : 3;
            const spacing = 18.0;
            final width = columns == 1
                ? constraints.maxWidth
                : (constraints.maxWidth - spacing * (columns - 1)) / columns;

            final cards = [
              _ActionCard(
                icon: Icons.search,
                title: 'Explorar experiencias',
                subtitle:
                    'Encuentra propuestas gastronómicas y culturales para visitar.',
                actionLabel: 'Explorar ahora',
                onTap: onExplore,
              ),
              _ActionCard(
                icon: Icons.storefront,
                title: 'Crear mi emprendimiento',
                subtitle:
                    'Solicita habilitar tu perfil para publicar un negocio local.',
                actionLabel: 'Iniciar solicitud',
                onTap: onPending,
              ),
              _ActionCard(
                icon: Icons.auto_awesome,
                title: 'Recomendaciones con IA',
                subtitle:
                    'Recibe ideas para rutas, contenidos y experiencias turísticas.',
                actionLabel: 'Ver recomendaciones',
                onTap: onPending,
              ),
            ];

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final card in cards)
                  SizedBox(width: width.toDouble(), child: card),
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
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: _ContentCard(
        child: Stack(
          children: [
            Positioned(
              right: -34,
              top: -34,
              child: Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: ClientHomeScreen._primaryColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    icon,
                    color: ClientHomeScreen._primaryColor,
                    size: 29,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    color: ClientHomeScreen._textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: ClientHomeScreen._mutedColor,
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionLabel,
                      style: const TextStyle(
                        color: ClientHomeScreen._primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right,
                      color: ClientHomeScreen._primaryColor,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  const _RecentActivitySection();

  @override
  Widget build(BuildContext context) {
    return _ContentCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              children: [
                const Expanded(
                  child: _SectionHeader(
                    title: 'Actividad reciente',
                    subtitle: 'Últimos movimientos desde tu cuenta.',
                  ),
                ),
                _OutlineOrangeButton(
                  label: 'Ver historial',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Esta funcionalidad se implementará después',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 34),
            child: Center(
              child: Text(
                'Todavía no tienes experiencias guardadas ni actividad registrada.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ClientHomeScreen._mutedColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: ClientHomeScreen._textColor,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: ClientHomeScreen._mutedColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 45,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _OrangeButton extends StatelessWidget {
  const _OrangeButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: ClientHomeScreen._primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
      ),
      child: Text(label),
    );
  }
}

class _OutlineOrangeButton extends StatelessWidget {
  const _OutlineOrangeButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: ClientHomeScreen._primaryColor,
        backgroundColor: const Color(0xFFFFF7ED),
        side: const BorderSide(color: Color(0xFFFED7AA)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
      ),
      child: Text(label),
    );
  }
}
