import "dart:typed_data";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class Post {
  String discription;
  String uid;
  String username;
  String postId;
  String datePublished;
  String postUrl;
  String profileImage;
  List likes;

  Post(
      {required this.discription,
      required this.uid,
      required this.username,
      required this.postId,
      required this.postUrl,
      required this.profileImage,
      required this.datePublished,
      required this.likes});

  Map<String, dynamic> toJson() => {
        "discription": discription,
        "uid": uid,
        "username": username,
        "postId": postId,
        "postUrl": postUrl,
        "profileImage": profileImage,
        "datePublished": datePublished,
        "likes": likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        discription: snapshot["discription"],
        uid: snapshot["uid"],
        username: snapshot["username"],
        postId: snapshot["postId"],
        postUrl: snapshot["postUrl"],
        profileImage: snapshot["profileImage"],
        datePublished: snapshot["datePublished"],
        likes:snapshot["likes"]
        );
  }
}
