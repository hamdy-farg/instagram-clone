import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:instagram_clone/model/post_model.dart";
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/storageMethods.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  uploudImage(Uint8List file, String discription, String uid, String username,
      String profileImage) async {
    String res;
    try {
      String postUrl =
          await StorageMethods().uploudImageToString("postesd", file, true);
      var postId = Uuid().v1();
      Post post = Post(
          discription: discription,
          uid: _firebaseAuth.currentUser!.uid,
          username: username,
          postId: postId,
          postUrl: postUrl,
          profileImage: profileImage,
          datePublished: DateTime.now().toString(),
          likes: []);

      await _firestore.collection("post").doc(postId).set(post.toJson());
      res = "successful uploud post";
      return (res);
    } catch (e) {
      res = e.toString();
      return res;
    }
  }

  deletPost(String postId) async {
    String res;
    try {
      await _firestore.collection("post").doc(postId).delete();
      res = "successful";
      return res;
    } catch (e) {
      res = e.toString();
      return (res);
    }
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance.collection("post").doc(postId).update({
          "likes": FieldValue.arrayRemove([
            uid
          ]) // go to like list in firebase and remove the user who remove his like by his id
        }); // we use update instead of set becuase we want to change one value
      } else {
        await FirebaseFirestore.instance.collection("post").doc(postId).update({
          "likes": FieldValue.arrayUnion(
              [uid]) // to add uid of user who want to add like
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> PostComment(String postId, String text, String uid, String name,
      String profilePic, List likes) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await FirebaseFirestore.instance
            .collection("post")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profilePic": profilePic,
          "name": name,
          "uid": uid,
          "text": text,
          "commentId": commentId,
          "datePublished": DateTime.now(),
          "likes": likes
        });
        print("successeddddddd");
      } else {
        print("text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  likeComment(String postId, String commentId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance!
            .collection("post")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayRemove([uid])
        });
        print("ol");
      } else {
        await FirebaseFirestore.instance!
            .collection("post")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayUnion([uid])
        });
        print("ok");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
