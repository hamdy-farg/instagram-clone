import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:uuid/uuid.dart";

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String photourl = "";
  Future<String> uploudImageToString(
      String childName, Uint8List file, bool isPost) async {
    try {
      Reference ref;
      if (isPost) {
        ref = _storage
            .ref()
            .child(childName)
            .child(_auth.currentUser!.uid)
            .child(Uuid().v1());
      } else {
        ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
      }
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      photourl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("${e.toString()}");
    }
    print(photourl);
    return (photourl);
  }

}
