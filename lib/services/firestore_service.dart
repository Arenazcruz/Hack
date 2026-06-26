import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get users =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get entrepreneurs =>
      _firestore.collection('entrepreneurs');

  CollectionReference<Map<String, dynamic>> get experiences =>
      _firestore.collection('experiences');

  Future<void> createUserProfile(UserProfile profile) async {
    try {
      await users
          .doc(profile.uid)
          .set(profile.toMap(), SetOptions(merge: true));
    } on FirebaseException catch (error) {
      throw FirestoreServiceException(_firestoreErrorMessage(error));
    }
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final snapshot = await users.doc(uid).get();
      final data = snapshot.data();

      if (!snapshot.exists || data == null) {
        return null;
      }

      return UserProfile.fromMap(data);
    } on FirebaseException catch (error) {
      throw FirestoreServiceException(_firestoreErrorMessage(error));
    }
  }

  Future<void> updateUserRole({
    required String uid,
    required String role,
  }) async {
    try {
      await users.doc(uid).set({'role': role}, SetOptions(merge: true));
    } on FirebaseException catch (error) {
      throw FirestoreServiceException(_firestoreErrorMessage(error));
    }
  }

  Stream<UserProfile?> watchUserProfile(String uid) {
    return users.doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();

      if (!snapshot.exists || data == null) {
        return null;
      }

      return UserProfile.fromMap(data);
    });
  }
}

class FirestoreServiceException implements Exception {
  const FirestoreServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

String _firestoreErrorMessage(FirebaseException error) {
  switch (error.code) {
    case 'permission-denied':
      return 'No tienes permisos para realizar esta acción.';
    case 'unavailable':
      return 'Firestore no está disponible en este momento.';
    case 'not-found':
      return 'No se encontró la información solicitada.';
    default:
      return error.message ?? 'Ocurrió un error al guardar la información.';
  }
}
