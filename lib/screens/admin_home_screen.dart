import 'package:flutter/material.dart';

import '../models/role_request.dart';
import '../services/auth_service.dart';
import '../services/role_request_service.dart';
import '../utils/display_labels.dart';
import '../widgets/dashboard_widgets.dart';
import 'welcome_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  static const routeName = '/admin-home';

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
    return SumaqDashboardScaffold(
      title: 'SUMAQ IA',
      onSignOut: () => _signOut(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DashboardHero(
                  title: 'Panel administrador',
                  subtitle:
                      'Gestión general de usuarios, emprendimientos, rutas y experiencias.',
                  icon: Icons.admin_panel_settings,
                ),
                const SizedBox(height: 26),
                const DashboardSectionTitle(title: 'Módulos de administración'),
                const SizedBox(height: 16),
                ResponsiveDashboardGrid(
                  children: [
                    DashboardActionCard(
                      icon: Icons.people,
                      title: 'Usuarios',
                      subtitle: 'Revisar perfiles y roles registrados.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.storefront,
                      title: 'Emprendimientos',
                      subtitle: 'Administrar negocios gastronómicos.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.restaurant,
                      title: 'Experiencias',
                      subtitle: 'Supervisar propuestas gastronómicas.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.route,
                      title: 'Rutas turísticas',
                      subtitle: 'Gestionar recorridos y servicios.',
                      onTap: () => _showPendingMessage(context),
                    ),
                    DashboardActionCard(
                      icon: Icons.auto_awesome,
                      title: 'Contenido IA',
                      subtitle: 'Monitorear generación de contenido.',
                      onTap: () => _showPendingMessage(context),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                const _VerificationRequestsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VerificationRequestsSection extends StatelessWidget {
  const _VerificationRequestsSection();

  @override
  Widget build(BuildContext context) {
    final service = RoleRequestService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionTitle(
          title: 'Solicitudes de verificación',
          subtitle:
              'Revisa datos reales del emprendimiento, negocio o ruta antes de aprobar el cambio de perfil.',
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<RoleRequest>>(
          stream: service.getPendingRoleRequestsForAdmin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return const DashboardCard(
                child: Text(
                  'No se pudieron cargar las solicitudes pendientes.',
                  style: TextStyle(
                    color: sumaqMutedTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }

            final requests = snapshot.data ?? const <RoleRequest>[];

            if (requests.isEmpty) {
              return const DashboardCard(
                child: Text(
                  'No hay solicitudes pendientes por ahora.',
                  style: TextStyle(
                    color: sumaqMutedTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }

            return Column(
              children: [
                for (final request in requests) ...[
                  _VerificationRequestCard(request: request, service: service),
                  if (request != requests.last) const SizedBox(height: 14),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _VerificationRequestCard extends StatelessWidget {
  const _VerificationRequestCard({
    required this.request,
    required this.service,
  });

  final RoleRequest request;
  final RoleRequestService service;

  Future<void> _approve(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aprobar solicitud'),
        content: const Text(
          '¿Aprobar esta solicitud y cambiar el rol del usuario?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: sumaqPrimaryColor),
            child: const Text('Aprobar'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) {
      return;
    }

    try {
      await service.approveRoleRequest(request);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud aprobada y perfil actualizado.'),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo aprobar la solicitud.')),
        );
      }
    }
  }

  Future<void> _reject(BuildContext context) async {
    final controller = TextEditingController();
    final comment = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechazar solicitud'),
        content: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Comentario del administrador',
            hintText: 'Explica brevemente el motivo del rechazo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            style: FilledButton.styleFrom(backgroundColor: sumaqPrimaryColor),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (comment == null || !context.mounted) {
      return;
    }

    try {
      await service.rejectRoleRequest(
        request,
        comment.isEmpty ? 'Solicitud rechazada.' : comment,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Solicitud rechazada.')));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo rechazar la solicitud.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = request.fechaSolicitud;
    final dateLabel = date == null
        ? 'Fecha no disponible'
        : '${date.day.toString().padLeft(2, '0')}/'
              '${date.month.toString().padLeft(2, '0')}/'
              '${date.year}';

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEFE6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.verified_user,
                  color: sumaqPrimaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.nombreLugar,
                      style: const TextStyle(
                        color: sumaqTextColor,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${request.nombreUsuario} • ${request.email}',
                      style: const TextStyle(
                        color: sumaqMutedTextColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip(label: 'Rol actual: ${roleLabel(request.rolActual)}'),
              _InfoChip(
                label: 'Rol solicitado: ${roleLabel(request.rolSolicitado)}',
              ),
              _InfoChip(label: requestTypeLabel(request.tipoSolicitud)),
              _InfoChip(label: dateLabel),
            ],
          ),
          const SizedBox(height: 18),
          _DetailGrid(items: _detailItems(request)),
          const SizedBox(height: 16),
          const Text(
            'Descripción',
            style: TextStyle(
              color: sumaqTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            request.descripcion,
            style: const TextStyle(
              color: sumaqMutedTextColor,
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => _reject(context),
                icon: const Icon(Icons.close),
                label: const Text('Rechazar solicitud'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: sumaqTextColor,
                  side: const BorderSide(color: Color(0xFFE7D6CA)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () => _approve(context),
                icon: const Icon(Icons.check),
                label: const Text('Aprobar solicitud'),
                style: FilledButton.styleFrom(
                  backgroundColor: sumaqPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

List<_DetailItem> _detailItems(RoleRequest request) {
  final isRoute = request.tipoSolicitud == 'ruta_turistica';
  final isGuide = request.tipoSolicitud == 'guia_turistico';
  final isGastronomic = request.tipoSolicitud == 'negocio_gastronomico';

  return [
    _DetailItem('Usuario', request.nombreUsuario),
    _DetailItem('Correo', request.email),
    _DetailItem(_nameLabel(request.tipoSolicitud), request.nombreLugar),
    _DetailItem('Ciudad', request.ciudad),
    _DetailItem(
      isRoute
          ? 'Punto de inicio'
          : isGuide
          ? 'Zonas donde puede trabajar'
          : 'Ubicación o dirección',
      request.ubicacion,
    ),
    _DetailItem('Teléfono de contacto', request.telefonoContacto),
    if (_hasText(request.categoria))
      _DetailItem(
        isGastronomic ? 'Tipo de comida' : 'Categoría',
        request.categoria!,
      ),
    if (_hasText(request.horarios))
      _DetailItem('Horarios de atención', request.horarios!),
    if (_hasText(request.tipoServicio))
      _DetailItem('Tipo de servicio turístico', request.tipoServicio!),
    if (_hasText(request.lugaresIncluidos))
      _DetailItem('Lugares incluidos', request.lugaresIncluidos!),
    if (_hasText(request.duracionAproximada))
      _DetailItem('Duración aproximada', request.duracionAproximada!),
    if (_hasText(request.experienciaPrevia))
      _DetailItem('Experiencia previa', request.experienciaPrevia!),
    if (_hasText(request.idiomas)) _DetailItem('Idiomas', request.idiomas!),
    if (_hasText(request.disponibilidad))
      _DetailItem('Disponibilidad', request.disponibilidad!),
    if (_hasText(request.referencias))
      _DetailItem('Referencias', request.referencias!),
    if (_hasText(request.redSocial))
      _DetailItem('Red social', request.redSocial!),
    if (_hasText(request.sitioWeb)) _DetailItem('Sitio web', request.sitioWeb!),
  ];
}

String _nameLabel(String type) {
  switch (type) {
    case 'guia_turistico':
      return 'Nombre para el perfil de guía';
    case 'ruta_turistica':
      return 'Nombre de la ruta turística';
    case 'negocio_gastronomico':
      return 'Nombre del negocio gastronómico';
    case 'emprendimiento':
      return 'Nombre del emprendimiento';
    default:
      return 'Nombre';
  }
}

class _DetailGrid extends StatelessWidget {
  const _DetailGrid({required this.items});

  final List<_DetailItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 760 ? 1 : 2;
        const spacing = 12.0;
        final width = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final item in items)
              SizedBox(
                width: width.toDouble(),
                child: _DetailTile(item: item),
              ),
          ],
        );
      },
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({required this.item});

  final _DetailItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF4E6DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.label,
            style: const TextStyle(
              color: sumaqMutedTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.value,
            style: const TextStyle(
              color: sumaqTextColor,
              fontSize: 14,
              height: 1.3,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem {
  const _DetailItem(this.label, this.value);

  final String label;
  final String value;
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4EC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFFFDEC6)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: sumaqPrimaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;
