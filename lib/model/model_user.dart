import "dart:typed_data";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class User {
  String email;
  String uid;
  String username;
  String bio;
  List followers;
  List following;
  String photourl;
  User(
      {required this.email,
      required this.uid,
      required this.username,
      required this.bio,
      required this.followers,
      required this.following,
      required this.photourl});

  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
        "username": username,
        "bio": bio,
        "followers": followers,
        "following": following,
        "photourl": photourl
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        email: snapshot["email"],
        uid: snapshot["uid"],
        username: snapshot["username"],
        bio: snapshot["bio"],
        followers: snapshot["followers"],
        following: snapshot["following"],
        photourl: snapshot["photourl"]);
  }
}

