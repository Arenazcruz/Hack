import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get entrepreneurs =>
      _firestore.collection('entrepreneurs');

  CollectionReference<Map<String, dynamic>> get experiences =>
      _firestore.collection('experiences');
}
