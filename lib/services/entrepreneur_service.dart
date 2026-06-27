import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/entrepreneur_profile.dart';
import 'auth_service.dart';

class EntrepreneurService {
  EntrepreneurService({FirebaseFirestore? firestore, AuthService? authService})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _authService = authService ?? AuthService();

  final FirebaseFirestore _firestore;
  final AuthService _authService;

  CollectionReference<Map<String, dynamic>> get _entrepreneurs =>
      _firestore.collection('entrepreneurs');

  Stream<EntrepreneurProfile?> streamMyEntrepreneurProfile() {
    final uid = _currentUid;
    return _entrepreneurs.doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();

      if (!snapshot.exists || data == null) {
        return null;
      }

      return EntrepreneurProfile.fromMap(data);
    });
  }

  Future<EntrepreneurProfile?> getMyEntrepreneurProfile() async {
    try {
      final snapshot = await _entrepreneurs.doc(_currentUid).get();
      final data = snapshot.data();

      if (!snapshot.exists || data == null) {
        return null;
      }

      return EntrepreneurProfile.fromMap(data);
    } on FirebaseException catch (error) {
      throw EntrepreneurServiceException(_message(error));
    }
  }

  Future<void> createOrUpdateProfile(EntrepreneurProfile profile) async {
    final uid = _currentUid;

    if (profile.uid != uid || profile.id != uid) {
      throw const EntrepreneurServiceException(
        'No puedes modificar un emprendimiento de otro usuario.',
      );
    }

    try {
      await _entrepreneurs
          .doc(uid)
          .set(profile.toMap(), SetOptions(merge: true));
    } on FirebaseException catch (error) {
      throw EntrepreneurServiceException(_message(error));
    }
  }

  String get _currentUid {
    final user = _authService.currentUser;

    if (user == null) {
      throw const EntrepreneurServiceException('Debes iniciar sesión.');
    }

    return user.uid;
  }
}

class EntrepreneurServiceException implements Exception {
  const EntrepreneurServiceException(this.message);

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
      return error.message ?? 'No se pudo guardar el emprendimiento.';
  }
}
