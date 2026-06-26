import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static const routeName = '/';
  static const welcomeRouteName = '/welcome';
  static const primaryColor = Color(0xFFE8671B);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const _heroImage = NetworkImage(
    'https://images.unsplash.com/photo-1551218808-94e220e084d2'
    '?auto=format&fit=crop&w=1200&q=80',
  );

  final _scrollController = ScrollController();
  final _inicioKey = GlobalKey();
  final _explorarKey = GlobalKey();
  final _iaKey = GlobalKey();
  final _impactoKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final sectionContext = key.currentContext;
    if (sectionContext == null || !_scrollController.hasClients) {
      return;
    }

    final box = sectionContext.findRenderObject() as RenderBox?;
    if (box == null) {
      return;
    }

    final headerHeight = _headerHeight(MediaQuery.sizeOf(context).width);
    final offset = box.localToGlobal(Offset.zero).dy;
    final target = _scrollController.offset + offset - headerHeight;
    final clampedTarget = math.max(
      0,
      math.min(target, _scrollController.position.maxScrollExtent),
    );

    _scrollController.animateTo(
      clampedTarget.toDouble(),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeInOutCubic,
    );
  }

  void _openLogin() {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  static double _headerHeight(double width) {
    return width < 900 ? 138 : 84;
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = _headerHeight(MediaQuery.sizeOf(context).width);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.only(top: headerHeight),
                child: Column(
                  children: [
                    _InicioSection(
                      key: _inicioKey,
                      heroImage: _heroImage,
                      onExplore: () => _scrollTo(_explorarKey),
                      onLogin: _openLogin,
                    ),
                    _ExploreSection(key: _explorarKey),
                    _AiSection(key: _iaKey),
                    _ImpactSection(key: _impactoKey),
                    const _Footer(),
                  ],
                ),
              ),
            ),
            _FixedHeader(
              height: headerHeight,
              onInicio: () => _scrollTo(_inicioKey),
              onExplorar: () => _scrollTo(_explorarKey),
              onIa: () => _scrollTo(_iaKey),
              onImpacto: () => _scrollTo(_impactoKey),
              onLogin: _openLogin,
            ),
          ],
        ),
      ),
    );
  }
}

class _FixedHeader extends StatelessWidget {
  const _FixedHeader({
    required this.height,
    required this.onInicio,
    required this.onExplorar,
    required this.onIa,
    required this.onImpacto,
    required this.onLogin,
  });

  final double height;
  final VoidCallback onInicio;
  final VoidCallback onExplorar;
  final VoidCallback onIa;
  final VoidCallback onImpacto;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 900;

    return Material(
      color: Colors.white,
      elevation: 7,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 16 : 24,
                vertical: isCompact ? 12 : 14,
              ),
              child: isCompact
                  ? Column(
                      children: [
                        Row(
                          children: [
                            const _Brand(),
                            const Spacer(),
                            _LoginButton(onPressed: onLogin),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _NavButton(label: 'Inicio', onPressed: onInicio),
                              _NavButton(
                                label: 'Explorar',
                                onPressed: onExplorar,
                              ),
                              _NavButton(label: 'IA', onPressed: onIa),
                              _NavButton(
                                label: 'Impacto',
                                onPressed: onImpacto,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        const _Brand(),
                        const Spacer(),
                        _NavButton(label: 'Inicio', onPressed: onInicio),
                        _NavButton(label: 'Explorar', onPressed: onExplorar),
                        _NavButton(label: 'IA', onPressed: onIa),
                        _NavButton(label: 'Impacto', onPressed: onImpacto),
                        const SizedBox(width: 16),
                        _LoginButton(onPressed: onLogin),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: WelcomeScreen.primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: WelcomeScreen.primaryColor.withValues(alpha: 0.26),
                blurRadius: 14,
                offset: const Offset(0, 8),
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
        const Text(
          'SUMAQ IA',
          style: TextStyle(
            color: Color(0xFF211B17),
            fontSize: 21,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF3A2B22),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
      ),
      child: Text(label),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: WelcomeScreen.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
      ),
      onPressed: onPressed,
      child: const Text('Ingresar'),
    );
  }
}

class _InicioSection extends StatelessWidget {
  const _InicioSection({
    required this.heroImage,
    required this.onExplore,
    required this.onLogin,
    super.key,
  });

  final ImageProvider heroImage;
  final VoidCallback onExplore;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeroBlock(image: heroImage, onExplore: onExplore, onLogin: onLogin),
        const _IntroBlocks(),
      ],
    );
  }
}

class _HeroBlock extends StatelessWidget {
  const _HeroBlock({
    required this.image,
    required this.onExplore,
    required this.onLogin,
  });

  final ImageProvider image;
  final VoidCallback onExplore;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 900;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [WelcomeScreen.primaryColor, Color(0xFFF58A32)],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        isCompact ? 20 : 32,
        isCompact ? 42 : 62,
        isCompact ? 20 : 32,
        isCompact ? 48 : 70,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Flex(
            direction: isCompact ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: isCompact ? 0 : 11,
                child: _HeroCopy(
                  isCompact: isCompact,
                  onExplore: onExplore,
                  onLogin: onLogin,
                ),
              ),
              SizedBox(width: isCompact ? 0 : 42, height: isCompact ? 30 : 0),
              Expanded(
                flex: isCompact ? 0 : 9,
                child: _HeroVisual(image: image),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.isCompact,
    required this.onExplore,
    required this.onLogin,
  });

  final bool isCompact;
  final VoidCallback onExplore;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isCompact
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Impulsa el turismo gastronómico boliviano con IA',
          textAlign: isCompact ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontSize: isCompact ? 36 : 56,
            height: 1.04,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'SUMAQ IA ayuda a emprendedores gastronómicos a convertir su '
          'comida, historia y cultura en experiencias turísticas atractivas.',
          textAlign: isCompact ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.93),
            fontSize: isCompact ? 17 : 20,
            height: 1.45,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 14,
          runSpacing: 12,
          alignment: isCompact ? WrapAlignment.center : WrapAlignment.start,
          children: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: WelcomeScreen.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              onPressed: onExplore,
              child: const Text('Explorar experiencias'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 1.4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              onPressed: onLogin,
              child: const Text('Ingresar'),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual({required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.08,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 28,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image(
                  image: image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const ColoredBox(
                      color: Color(0xFFFFEFE6),
                      child: Center(
                        child: Icon(
                          Icons.local_dining,
                          color: WelcomeScreen.primaryColor,
                          size: 72,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            left: 22,
            bottom: 22,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'IA + Turismo',
                    style: TextStyle(
                      color: WelcomeScreen.primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Experiencias inteligentes',
                    style: TextStyle(
                      color: Color(0xFF3A2B22),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroBlocks extends StatelessWidget {
  const _IntroBlocks();

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: '¿Qué es SUMAQ IA?',
            subtitle:
                'Una plataforma para transformar comida local, cultura y '
                'emprendimiento en experiencias turísticas memorables.',
          ),
          const SizedBox(height: 24),
          const _ResponsiveCards(
            children: [
              _InfoCard(
                icon: Icons.restaurant,
                title: 'Gastronomía',
                text: 'Promueve sabores auténticos y emprendimientos locales.',
              ),
              _InfoCard(
                icon: Icons.travel_explore,
                title: 'Turismo',
                text:
                    'Convierte comidas tradicionales en experiencias para visitantes.',
              ),
              _InfoCard(
                icon: Icons.auto_awesome,
                title: 'Inteligencia Artificial',
                text:
                    'Gemini genera historias, descripciones, rutas y contenido promocional.',
              ),
            ],
          ),
          const SizedBox(height: 54),
          const _SectionHeading(
            title: '¿Cómo funciona?',
            subtitle:
                'Un flujo simple para que el emprendedor publique mejor y el '
                'turista descubra experiencias con identidad.',
          ),
          const SizedBox(height: 24),
          const _ResponsiveCards(
            preferredWidth: 250,
            children: [
              _StepCard(
                number: '1',
                text: 'El emprendedor registra su experiencia.',
              ),
              _StepCard(
                number: '2',
                text: 'Gemini mejora la historia y presentación.',
              ),
              _StepCard(
                number: '3',
                text: 'El turista descubre rutas gastronómicas.',
              ),
              _StepCard(
                number: '4',
                text: 'La visita fortalece la economía local.',
              ),
            ],
          ),
          const SizedBox(height: 54),
          const _ResponsiveCards(
            preferredWidth: 240,
            children: [
              _StatCard(value: '120+', label: 'Experiencias potenciales'),
              _StatCard(value: '35+', label: 'Ciudades y destinos'),
              _StatCard(value: '500+', label: 'Usuarios proyectados'),
              _StatCard(value: '90%', label: 'Más visibilidad esperada'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExploreSection extends StatelessWidget {
  const _ExploreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      backgroundColor: const Color(0xFFFFFAF6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Explora experiencias gastronómicas',
            subtitle:
                'Descubre rutas, sabores y emprendimientos locales pensados '
                'para turistas que buscan vivir Bolivia desde su gastronomía.',
          ),
          const SizedBox(height: 24),
          const _ResponsiveCards(
            children: [
              _ExperienceCard(
                title: 'Ruta de Salteñas Paceñas',
                city: 'La Paz',
                text:
                    'Una experiencia para descubrir la historia y sabor de las salteñas tradicionales.',
                icon: Icons.bakery_dining,
              ),
              _ExperienceCard(
                title: 'Api con Pastel',
                city: 'El Alto',
                text:
                    'Desayuno tradicional con identidad cultural y sabor local.',
                icon: Icons.local_cafe,
              ),
              _ExperienceCard(
                title: 'Cocina Andina',
                city: 'Sucre',
                text:
                    'Sabores tradicionales convertidos en experiencia turística.',
                icon: Icons.dinner_dining,
              ),
            ],
          ),
          const SizedBox(height: 36),
          const Text(
            'Categorías',
            style: TextStyle(
              color: Color(0xFF211B17),
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _CategoryChip(label: 'Comida típica'),
              _CategoryChip(label: 'Cafeterías'),
              _CategoryChip(label: 'Bebidas tradicionales'),
              _CategoryChip(label: 'Mercados locales'),
              _CategoryChip(label: 'Postres'),
              _CategoryChip(label: 'Cocina andina'),
            ],
          ),
        ],
      ),
    );
  }
}

class _AiSection extends StatelessWidget {
  const _AiSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: '¿Cómo ayuda Gemini en SUMAQ IA?',
            subtitle:
                'La inteligencia artificial no reemplaza al emprendedor: lo '
                'ayuda a contar mejor su historia, organizar su oferta y '
                'llegar a más turistas.',
          ),
          const SizedBox(height: 24),
          const _ResponsiveCards(
            preferredWidth: 260,
            children: [
              _InfoCard(
                icon: Icons.history_edu,
                title: 'Generación de historias',
                text:
                    'Convierte una descripción simple en una narrativa turística atractiva.',
              ),
              _InfoCard(
                icon: Icons.campaign,
                title: 'Contenido promocional',
                text:
                    'Crea textos para redes sociales, anuncios y presentaciones.',
              ),
              _InfoCard(
                icon: Icons.route,
                title: 'Rutas personalizadas',
                text:
                    'Sugiere recorridos según ciudad, presupuesto y tiempo disponible.',
              ),
              _InfoCard(
                icon: Icons.tips_and_updates,
                title: 'Recomendaciones inteligentes',
                text:
                    'Ayuda a mejorar precios, combos y presentación del emprendimiento.',
              ),
            ],
          ),
          const SizedBox(height: 34),
          const _AiExample(),
        ],
      ),
    );
  }
}

class _ImpactSection extends StatelessWidget {
  const _ImpactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      backgroundColor: const Color(0xFFFFFAF6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Impacto esperado',
            subtitle:
                'SUMAQ IA busca aumentar la visibilidad de pequeños '
                'emprendedores, fortalecer el turismo local y promover la '
                'gastronomía boliviana con apoyo de inteligencia artificial.',
          ),
          const SizedBox(height: 24),
          const _ProblemSolutionBlock(),
          const SizedBox(height: 34),
          const _ResponsiveCards(
            children: [
              _InfoCard(
                icon: Icons.storefront,
                title: 'Para emprendedores',
                text:
                    'Más visibilidad, mejor presentación y nuevas oportunidades de ingreso.',
              ),
              _InfoCard(
                icon: Icons.map,
                title: 'Para turistas',
                text:
                    'Rutas auténticas, recomendaciones claras y experiencias locales.',
              ),
              _InfoCard(
                icon: Icons.flag,
                title: 'Para Bolivia',
                text:
                    'Impulso al turismo gastronómico, cultura e innovación tecnológica.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.child,
    this.backgroundColor = Colors.white,
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 58),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: child,
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.subtitle});

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
            color: Color(0xFF211B17),
            fontSize: 34,
            height: 1.1,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF6F625A),
              fontSize: 17,
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ResponsiveCards extends StatelessWidget {
  const _ResponsiveCards({required this.children, this.preferredWidth = 330});

  final List<Widget> children;
  final double preferredWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 18.0;
        final maxWidth = constraints.maxWidth;
        final columns = maxWidth < 720
            ? 1
            : math.max(
                1,
                math.min(children.length, maxWidth ~/ preferredWidth),
              );
        final itemWidth = columns == 1
            ? maxWidth
            : (maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth.toDouble(), child: child),
          ],
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: icon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF211B17),
                    fontSize: 17,
                    height: 1.18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
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
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: WelcomeScreen.primaryColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF3A2B22),
              fontSize: 16,
              height: 1.35,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: WelcomeScreen.primaryColor,
              fontSize: 30,
              height: 1.05,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF3A2B22),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({
    required this.title,
    required this.city,
    required this.text,
    required this.icon,
  });

  final String title;
  final String city;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: icon),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF211B17),
              fontSize: 18,
              height: 1.18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            city,
            style: const TextStyle(
              color: WelcomeScreen.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF6F625A),
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFF2D8C8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF3A2B22),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _AiExample extends StatelessWidget {
  const _AiExample();

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 720;
          final input = _ExamplePane(
            label: 'Entrada',
            text: 'Tengo un puesto de api con pastel en El Alto.',
          );
          final output = _ExamplePane(
            label: 'Salida IA',
            text:
                'Gemini genera una experiencia cultural con historia, menú '
                'sugerido, descripción para turistas y publicación para redes sociales.',
            emphasized: true,
          );

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [input, const SizedBox(height: 14), output],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: input),
              const SizedBox(width: 18),
              Expanded(child: output),
            ],
          );
        },
      ),
    );
  }
}

class _ExamplePane extends StatelessWidget {
  const _ExamplePane({
    required this.label,
    required this.text,
    this.emphasized = false,
  });

  final String label;
  final String text;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: emphasized ? const Color(0xFFFFEFE6) : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: emphasized ? const Color(0xFFF2D8C8) : const Color(0xFFEFEFEF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: WelcomeScreen.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF3A2B22),
              fontSize: 15,
              height: 1.45,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProblemSolutionBlock extends StatelessWidget {
  const _ProblemSolutionBlock();

  @override
  Widget build(BuildContext context) {
    return const _ResponsiveCards(
      children: [
        _BulletCard(
          title: 'Problema',
          items: [
            'Muchos emprendimientos gastronómicos tienen poca visibilidad.',
            'Los turistas no siempre encuentran experiencias locales auténticas.',
            'Crear contenido promocional toma tiempo y requiere conocimientos digitales.',
          ],
        ),
        _BulletCard(
          title: 'Solución',
          items: [
            'SUMAQ IA conecta emprendedores con turistas.',
            'Gemini ayuda a crear contenido atractivo.',
            'La app convierte comida local en experiencias turísticas.',
          ],
        ),
      ],
    );
  }
}

class _BulletCard extends StatelessWidget {
  const _BulletCard({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF211B17),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: Icon(
                    Icons.circle,
                    color: WelcomeScreen.primaryColor,
                    size: 8,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Color(0xFF6F625A),
                      fontSize: 15,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (item != items.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFE6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: WelcomeScreen.primaryColor, size: 28),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF211B17),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Wrap(
            spacing: 24,
            runSpacing: 14,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'SUMAQ IA - Construido con Flutter, Firebase y Gemini API',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Wrap(
                spacing: 16,
                children: const [
                  _FooterLink(label: 'GitHub'),
                  _FooterLink(label: 'Demo'),
                  _FooterLink(label: 'Equipo'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.82),
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
