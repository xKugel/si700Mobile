import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;

class StorageServer {
  // Atributo que irá afunilar todas as consultas
  static StorageServer helper = StorageServer._createInstance();
  // Construtor privado
  StorageServer._createInstance();

  Reference noteImage = FirebaseStorage.instance.ref().child("images");

  UploadTask? insertImage(String uid, String noteId, Uint8List? path) {
    try {
      var ref = noteImage.child(uid).child(noteId + ".jpeg");
      return ref.putData(path!);
    } on FirebaseException {
      return null;
    }
  }

  deleteImage(String uid, String noteId) {
    noteImage.child(uid).child(noteId + ".jpeg").delete();
  }
}
