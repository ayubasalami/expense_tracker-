import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await storage
        .ref('users/${FirebaseAuth.instance.currentUser?.uid}')
        .child('profilepic.jpg')
        .getDownloadURL();
    return downloadURL;
  }
}
