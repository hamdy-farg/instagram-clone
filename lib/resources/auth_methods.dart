import "dart:html";
import "dart:js_interop";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/widgets.dart";
import "package:instagram_clone/main.dart";
import "package:instagram_clone/model/model_user.dart" as model;
import "package:instagram_clone/resources/storageMethods.dart";
import "package:instagram_clone/responsive/mobileScreen.dart";
import "package:instagram_clone/model/model_user.dart" as Users;
import "package:instagram_clone/model/post_model.dart";
class Methods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    DocumentSnapshot<Map<String, dynamic>> Snap = await _firestore
        .collection("Userdata")
        .doc(_auth.currentUser!.uid)
        .get();
    return model.User.fromSnap(Snap);
  }



  signupUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String result = "if error accured";
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String photourl;
      photourl = await StorageMethods()
          .uploudImageToString("profilePics", file, false);

      model.User user = model.User(
        email: email,
        uid: _auth.currentUser!.uid,
        username: username,
        bio: bio,
        photourl: photourl,
        followers: [],
        following: [],
      );
      await _firestore
          .collection("Userdata")
          .doc(userCredential.user!.uid)
          .set(user.toJson());
      if (!_auth.currentUser!.emailVerified) {
        _auth.currentUser!.sendEmailVerification();
        throw ("email not verfied");
      }

      result = "successful signup";

      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => MyApp())));
    } catch (e) {
      result = e.toString();
      print("$e");
    }
    return (result);
  }

  // login method to make user save his credential in firebase
  // @ email: user Entered email
  // @ password : user Entered password
  // @ context : location of the user in the stack
  loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String result = "if some error accured";
    print("resul");
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      result = "successful login";
      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => MyApp())));
    } on FirebaseAuthException catch (e) {
      result = e.toString();
    }
    print(result);

    try {
      await _auth.sendPasswordResetEmail(email: email);
      result = "password reset was sent to your email";
    } catch (e) {
      result = e.toString();
    }
    return (result);
  }

  String passwordResset({required String email}) {
    try {
      _auth.sendPasswordResetEmail(email: email);
      return ('password reset email was sent');
    } catch (e) {
      return (e.toString());
    }
  }
}
