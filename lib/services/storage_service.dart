import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadExperienceImage({
    required String ownerId,
    required File file,
  }) async {
    final ref = _storage
        .ref()
        .child('experiences')
        .child(ownerId)
        .child(DateTime.now().millisecondsSinceEpoch.toString());

    final result = await ref.putFile(file);
    return result.ref.getDownloadURL();
  }
}
