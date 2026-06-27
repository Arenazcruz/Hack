import 'package:flutter/material.dart';

import '../models/entrepreneur_product.dart';
import '../services/entrepreneur_product_service.dart';
import 'entrepreneur_product_form_screen.dart';

class EntrepreneurProductsScreen extends StatelessWidget {
  const EntrepreneurProductsScreen({super.key});

  static const routeName = '/entrepreneur/products';
  static const _primaryColor = Color(0xFFE8671B);
  static const _backgroundColor = Color(0xFFFFF8F4);
  static const _textColor = Color(0xFF211B17);
  static const _mutedTextColor = Color(0xFF6F625A);

  void _openCreate(BuildContext context) {
    Navigator.pushNamed(context, EntrepreneurProductFormScreen.routeName);
  }

  void _openEdit(BuildContext context, EntrepreneurProduct product) {
    Navigator.pushNamed(
      context,
      EntrepreneurProductFormScreen.routeName,
      arguments: EntrepreneurProductFormArgs(product: product),
    );
  }

  Future<void> _delete(
    BuildContext context,
    EntrepreneurProduct product,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto o servicio'),
        content: const Text('¿Eliminar este producto o servicio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: _primaryColor),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) {
      return;
    }

    try {
      await EntrepreneurProductService().deleteProduct(product.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto o servicio eliminado.')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _Header(onAdd: () => _openCreate(context)),
            Expanded(
              child: StreamBuilder<List<EntrepreneurProduct>>(
                stream: EntrepreneurProductService().streamMyProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('No se pudieron cargar los productos.'),
                    );
                  }

                  final products =
                      snapshot.data ?? const <EntrepreneurProduct>[];

                  if (products.isEmpty) {
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: _Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.inventory_2_outlined,
                                color: _primaryColor,
                                size: 46,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Aún no registraste productos o servicios.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 18),
                              FilledButton.icon(
                                onPressed: () => _openCreate(context),
                                icon: const Icon(Icons.add),
                                label: const Text(
                                  'Agregar producto o servicio',
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: _primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1180),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final columns = constraints.maxWidth < 820
                                  ? 1
                                  : 2;
                              const spacing = 18.0;
                              final width = columns == 1
                                  ? constraints.maxWidth
                                  : (constraints.maxWidth -
                                            spacing * (columns - 1)) /
                                        columns;

                              return Wrap(
                                spacing: spacing,
                                runSpacing: spacing,
                                children: [
                                  for (final product in products)
                                    SizedBox(
                                      width: width.toDouble(),
                                      child: _ProductCard(
                                        product: product,
                                        onEdit: () =>
                                            _openEdit(context, product),
                                        onDelete: () =>
                                            _delete(context, product),
                                      ),
                                    ),
                                ],
                              );
                            },
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
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onAdd});

  final VoidCallback onAdd;

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
                      const _TitleBlock(),
                      const SizedBox(height: 14),
                      _AddButton(onAdd: onAdd),
                    ],
                  )
                : Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 10),
                      const _TitleBlock(),
                      const Spacer(),
                      _AddButton(onAdd: onAdd),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Productos y servicios',
          style: TextStyle(
            color: EntrepreneurProductsScreen._textColor,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Gestiona lo que ofrece tu emprendimiento.',
          style: TextStyle(
            color: EntrepreneurProductsScreen._mutedTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onAdd,
      icon: const Icon(Icons.add),
      label: const Text('Agregar producto o servicio'),
      style: FilledButton.styleFrom(
        backgroundColor: EntrepreneurProductsScreen._primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        textStyle: const TextStyle(fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  final EntrepreneurProduct product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: const TextStyle(
                    color: EntrepreneurProductsScreen._textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _StatusBadge(available: product.available),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Badge(label: product.category),
              _Badge(label: product.city),
              if (product.price != null)
                _Badge(label: 'Bs ${product.price!.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            product.description,
            style: const TextStyle(
              color: EntrepreneurProductsScreen._mutedTextColor,
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
                label: const Text('Editar'),
                style: TextButton.styleFrom(
                  foregroundColor: EntrepreneurProductsScreen._primaryColor,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Eliminar'),
                style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.available});

  final bool available;

  @override
  Widget build(BuildContext context) {
    final color = available ? const Color(0xFF15803D) : const Color(0xFFB91C1C);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        available ? 'Disponible' : 'No disponible',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFE6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFFFDEC6)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: EntrepreneurProductsScreen._primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
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
