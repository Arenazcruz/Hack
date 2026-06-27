import 'package:flutter/material.dart';

import '../services/role_request_service.dart';
import '../widgets/primary_button.dart';

class EntrepreneurRequestFormScreen extends StatefulWidget {
  const EntrepreneurRequestFormScreen({super.key});

  static const routeName = '/entrepreneur-request';

  @override
  State<EntrepreneurRequestFormScreen> createState() =>
      _EntrepreneurRequestFormScreenState();
}

class _EntrepreneurRequestFormScreenState
    extends State<EntrepreneurRequestFormScreen> {
  static const _primaryColor = Color(0xFFE8671B);
  static const _backgroundColor = Color(0xFFFFF8F4);
  static const _textColor = Color(0xFF211B17);

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _redSocialController = TextEditingController();
  final _service = RoleRequestService();

  String? _categoria;
  bool _isLoading = false;

  static const _categories = [
    'Comida tradicional',
    'Repostería',
    'Bebidas',
    'Productos artesanales',
    'Catering',
    'Otro',
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _ciudadController.dispose();
    _ubicacionController.dispose();
    _descripcionController.dispose();
    _telefonoController.dispose();
    _redSocialController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _service.createEntrepreneurRequest(
        nombreLugar: _nombreController.text,
        ciudad: _ciudadController.text,
        ubicacion: _ubicacionController.text,
        categoria: _categoria!,
        descripcion: _descripcionController.text,
        telefonoContacto: _telefonoController.text,
        redSocial: _redSocialController.text,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud enviada al administrador para revisión.'),
        ),
      );
      Navigator.pop(context);
    } on RoleRequestException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo enviar la solicitud. Inténtalo nuevamente.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _RequestShell(
      title: 'Solicitar perfil de emprendedor',
      subtitle:
          'Completa los datos de tu emprendimiento para que el administrador pueda verificar tu solicitud.',
      child: _formCard(),
    );
  }

  Widget _formCard() {
    return _RequestCard(
      title: 'Datos del emprendimiento',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _field(
              controller: _nombreController,
              label: 'Nombre del emprendimiento',
              hint: 'Ej. Sumaq Sabores Artesanales',
              validator: _required,
            ),
            const SizedBox(height: 14),
            _field(
              controller: _ciudadController,
              label: 'Ciudad',
              hint: 'Ej. La Paz',
              validator: _required,
            ),
            const SizedBox(height: 14),
            _field(
              controller: _ubicacionController,
              label: 'Dirección o zona donde trabaja',
              hint: 'Ej. Sopocachi, calle Ecuador',
              validator: _required,
            ),
            const SizedBox(height: 14),
            _dropdown(
              label: 'Categoría del emprendimiento',
              value: _categoria,
              options: _categories,
              onChanged: (value) => setState(() => _categoria = value),
            ),
            const SizedBox(height: 14),
            _field(
              controller: _descripcionController,
              label: 'Descripción del emprendimiento',
              hint:
                  'Cuéntanos qué ofrece tu emprendimiento, qué lo hace especial y a quién está dirigido.',
              minLines: 4,
              maxLines: 6,
              validator: _description,
            ),
            const SizedBox(height: 14),
            _field(
              controller: _telefonoController,
              label: 'Teléfono de contacto',
              keyboardType: TextInputType.phone,
              validator: _required,
            ),
            const SizedBox(height: 14),
            _field(
              controller: _redSocialController,
              label: 'Red social o referencia',
              hint: 'Instagram, Facebook o referencia de confianza',
            ),
            const SizedBox(height: 22),
            PrimaryButton(
              label: 'Enviar solicitud de emprendimiento',
              isLoading: _isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: [
        for (final option in options)
          DropdownMenuItem(value: option, child: Text(option)),
      ],
      onChanged: _isLoading ? null : onChanged,
      validator: (value) => value == null ? 'Campo obligatorio' : null,
      decoration: _inputDecoration(label),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      decoration: _inputDecoration(label).copyWith(hintText: hint),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFFFFAF6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFF4E6DC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFF4E6DC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _primaryColor, width: 1.5),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }

  String? _description(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Campo obligatorio';
    }
    if (text.length < 20) {
      return 'La descripción debe tener al menos 20 caracteres';
    }
    return null;
  }
}

class _RequestShell extends StatelessWidget {
  const _RequestShell({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      backgroundColor: _EntrepreneurRequestFormScreenState._backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _IntroPanel(title: title, subtitle: subtitle),
                        ),
                        const SizedBox(width: 24),
                        Expanded(flex: 2, child: child),
                      ],
                    )
                  : Column(
                      children: [
                        _IntroPanel(title: title, subtitle: subtitle),
                        const SizedBox(height: 20),
                        child,
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroPanel extends StatelessWidget {
  const _IntroPanel({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _EntrepreneurRequestFormScreenState._primaryColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _EntrepreneurRequestFormScreenState._primaryColor.withValues(
              alpha: 0.22,
            ),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: _EntrepreneurRequestFormScreenState._primaryColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              height: 1.08,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 16,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF4E6DC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                color: _EntrepreneurRequestFormScreenState._textColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _EntrepreneurRequestFormScreenState._textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}
