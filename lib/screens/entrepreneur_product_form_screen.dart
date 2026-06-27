import 'package:flutter/material.dart';

import '../models/entrepreneur_product.dart';
import '../services/entrepreneur_product_service.dart';
import '../widgets/primary_button.dart';

class EntrepreneurProductFormArgs {
  const EntrepreneurProductFormArgs({this.product});

  final EntrepreneurProduct? product;
}

class EntrepreneurProductFormScreen extends StatefulWidget {
  const EntrepreneurProductFormScreen({this.product, super.key});

  static const routeName = '/entrepreneur/products/form';

  final EntrepreneurProduct? product;

  @override
  State<EntrepreneurProductFormScreen> createState() =>
      _EntrepreneurProductFormScreenState();
}

class _EntrepreneurProductFormScreenState
    extends State<EntrepreneurProductFormScreen> {
  static const _primaryColor = Color(0xFFE8671B);
  static const _backgroundColor = Color(0xFFFFF8F4);
  static const _textColor = Color(0xFF211B17);
  static const _mutedTextColor = Color(0xFF6F625A);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _cityController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _service = EntrepreneurProductService();

  String? _category;
  bool _available = true;
  bool _isSaving = false;

  static const _categories = [
    'Producto gastronómico',
    'Servicio gastronómico',
    'Bebida',
    'Repostería',
    'Experiencia breve',
    'Paquete turístico',
    'Otro',
  ];

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    if (product != null) {
      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _priceController.text = product.price?.toString() ?? '';
      _cityController.text = product.city;
      _imageUrlController.text = product.imageUrl ?? '';
      _category = product.category.isEmpty ? null : product.category;
      _available = product.available;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _cityController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final priceText = _priceController.text.trim().replaceAll(',', '.');
      final price = priceText.isEmpty ? null : double.parse(priceText);
      final imageUrl = _clean(_imageUrlController.text);
      final base = widget.product;
      final product = EntrepreneurProduct(
        id: base?.id ?? '',
        ownerUid: base?.ownerUid ?? '',
        businessId: base?.businessId ?? '',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category!,
        price: price,
        city: _cityController.text.trim(),
        available: _available,
        imageUrl: imageUrl,
        createdAt: base?.createdAt,
        updatedAt: base?.updatedAt,
      );

      if (_isEditing) {
        await _service.updateProduct(product);
      } else {
        await _service.createProduct(product);
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Producto o servicio actualizado.'
                : 'Producto o servicio guardado.',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 880),
              child: Container(
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: _isSaving
                                ? null
                                : () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                            color: _textColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isEditing
                                      ? 'Editar producto o servicio'
                                      : 'Agregar producto o servicio',
                                  style: const TextStyle(
                                    color: _textColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Completa la información que ofrecerá tu emprendimiento.',
                                  style: TextStyle(
                                    color: _mutedTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _field(
                        controller: _nameController,
                        label: 'Nombre del producto o servicio',
                        validator: _required,
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        items: [
                          for (final category in _categories)
                            DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                        ],
                        onChanged: _isSaving
                            ? null
                            : (value) => setState(() => _category = value),
                        validator: (value) =>
                            value == null ? 'Campo obligatorio' : null,
                        decoration: _inputDecoration('Categoría'),
                      ),
                      const SizedBox(height: 14),
                      _field(
                        controller: _descriptionController,
                        label: 'Descripción',
                        minLines: 4,
                        maxLines: 6,
                        validator: _description,
                      ),
                      const SizedBox(height: 14),
                      _field(
                        controller: _priceController,
                        label: 'Precio referencial',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _price,
                      ),
                      const SizedBox(height: 14),
                      _field(
                        controller: _cityController,
                        label: 'Ciudad',
                        validator: _required,
                      ),
                      const SizedBox(height: 14),
                      SwitchListTile(
                        value: _available,
                        onChanged: _isSaving
                            ? null
                            : (value) => setState(() => _available = value),
                        contentPadding: EdgeInsets.zero,
                        activeThumbColor: _primaryColor,
                        title: const Text(
                          'Disponible',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          _available
                              ? 'Se mostrará como disponible.'
                              : 'Se mostrará como no disponible.',
                        ),
                      ),
                      const SizedBox(height: 14),
                      _field(
                        controller: _imageUrlController,
                        label: 'URL de imagen opcional',
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: _isEditing
                            ? 'Actualizar producto'
                            : 'Guardar producto',
                        isLoading: _isSaving,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
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
      decoration: _inputDecoration(label),
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
    if (text.length < 10) {
      return 'La descripción debe tener al menos 10 caracteres';
    }
    return null;
  }

  String? _price(String? value) {
    final text = value?.trim().replaceAll(',', '.') ?? '';
    if (text.isEmpty) {
      return null;
    }

    if (double.tryParse(text) == null) {
      return 'Ingresa un precio numérico';
    }

    return null;
  }
}

String? _clean(String value) {
  final text = value.trim();
  return text.isEmpty ? null : text;
}
