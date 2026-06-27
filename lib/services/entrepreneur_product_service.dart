import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/entrepreneur_product.dart';
import 'auth_service.dart';

class EntrepreneurProductService {
  EntrepreneurProductService({
    FirebaseFirestore? firestore,
    AuthService? authService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _authService = authService ?? AuthService();

  final FirebaseFirestore _firestore;
  final AuthService _authService;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('entrepreneur_products');

  Stream<List<EntrepreneurProduct>> streamMyProducts() {
    final uid = _currentUid;

    return _products.where('ownerUid', isEqualTo: uid).snapshots().map((
      snapshot,
    ) {
      final products = snapshot.docs
          .map((doc) => EntrepreneurProduct.fromMap(doc.data()))
          .toList();
      products.sort((a, b) {
        final aDate = a.updatedAt ?? a.createdAt ?? DateTime(0);
        final bDate = b.updatedAt ?? b.createdAt ?? DateTime(0);
        return bDate.compareTo(aDate);
      });
      return products;
    });
  }

  Future<void> createProduct(EntrepreneurProduct product) async {
    final uid = _currentUid;
    final doc = _products.doc();
    final now = DateTime.now();

    final productToSave = product.copyWith(
      id: doc.id,
      ownerUid: uid,
      businessId: uid,
      createdAt: now,
      updatedAt: now,
      clearPrice: product.price == null,
      clearImageUrl: product.imageUrl == null,
    );

    try {
      await doc.set(productToSave.toMap());
    } on FirebaseException catch (error) {
      throw EntrepreneurProductServiceException(_message(error));
    }
  }

  Future<void> updateProduct(EntrepreneurProduct product) async {
    final uid = _currentUid;

    if (product.id.isEmpty) {
      throw const EntrepreneurProductServiceException(
        'No se encontró el producto o servicio.',
      );
    }

    if (product.ownerUid.isNotEmpty && product.ownerUid != uid) {
      throw const EntrepreneurProductServiceException(
        'No puedes modificar productos de otro usuario.',
      );
    }

    final productToSave = product.copyWith(
      ownerUid: uid,
      businessId: product.businessId.isEmpty ? uid : product.businessId,
      updatedAt: DateTime.now(),
      clearPrice: product.price == null,
      clearImageUrl: product.imageUrl == null,
    );

    try {
      await _products
          .doc(product.id)
          .set(productToSave.toMap(), SetOptions(merge: true));
    } on FirebaseException catch (error) {
      throw EntrepreneurProductServiceException(_message(error));
    }
  }

  Future<void> deleteProduct(String productId) async {
    if (productId.trim().isEmpty) {
      throw const EntrepreneurProductServiceException(
        'No se encontró el producto o servicio.',
      );
    }

    try {
      await _products.doc(productId).delete();
    } on FirebaseException catch (error) {
      throw EntrepreneurProductServiceException(_message(error));
    }
  }

  String get _currentUid {
    final user = _authService.currentUser;

    if (user == null) {
      throw const EntrepreneurProductServiceException('Debes iniciar sesión.');
    }

    return user.uid;
  }
}

class EntrepreneurProductServiceException implements Exception {
  const EntrepreneurProductServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

String _message(FirebaseException error) {
  switch (error.code) {
    case 'permission-denied':
      return 'No tienes permisos para realizar esta acción.';
    case 'unavailable':
      return 'Firestore no está disponible en este momento.';
    default:
      return error.message ?? 'No se pudo guardar el producto o servicio.';
  }
}
