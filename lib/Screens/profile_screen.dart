import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/utils/Colors.dart';
import 'package:instagram_clone/utils/Utils.dart';
import 'package:instagram_clone/utils/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  bool isLouding = true;
  int postLen = 0;
  bool isFollowing = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("Userdata")
          .doc(widget.uid)
          .get();
      // get post LENGTH
      QuerySnapshot<Map<String, dynamic>> postSnap = await FirebaseFirestore
          .instance
          .collection("post")
          .where("uid", isEqualTo: widget.uid)
          .get();
      postLen = await postSnap.docs!.length;
      userData = (snap.data() as Map<String, dynamic>);
      if (userData["followers"]
          .contains(FirebaseAuth.instance.currentUser!.uid)) isFollowing = true;
      setState(() {
        isLouding = false;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return isLouding
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgournd,
              title: Text(userData["username"]),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userData["photourl"]),
                            radius: 40,
                            backgroundColor: Colors.grey,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStateColumn(postLen, "posts"),
                                    buildStateColumn(
                                        userData["followers"].length,
                                        "followers"),
                                    buildStateColumn(
                                        userData["following"].length,
                                        "following")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: "Edit Profile",
                                            backgroundColor: mobileBackgournd,
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            function: () {},
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: "unFollow",
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  try {
                                                    if (userData["followers"]
                                                        .toString()
                                                        .contains(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid))
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "Userdata")
                                                          .doc(widget.uid)
                                                          .update({
                                                        "followers": FieldValue
                                                            .arrayRemove([
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid
                                                        ])
                                                      });
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("Userdata")
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .update({
                                                      "following": FieldValue
                                                          .arrayRemove(
                                                              [widget.uid])
                                                    });
                                                    setState(() {
                                                      isFollowing = false;
                                                    });
                                                  } catch (e) {
                                                    print(e.toString());
                                                  }
                                                },
                                              )
                                            : FollowButton(
                                                text: "Follow",
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  try {
                                                    if (userData["followers"]
                                                            .toString()
                                                            .contains(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid) ==
                                                        false)
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "Userdata")
                                                          .doc(widget.uid)
                                                          .update({
                                                        "followers": FieldValue
                                                            .arrayUnion([
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid
                                                        ])
                                                      });
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("Userdata")
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .update({
                                                      "following":
                                                          FieldValue.arrayUnion(
                                                              [widget.uid])
                                                    });
                                                    setState(() {
                                                      isFollowing = true;
                                                    });
                                                  } catch (e) {
                                                    print(e.toString());
                                                  }
                                                })
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          userData["username"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 1),
                        child: Text(userData["email"]),
                      ),
                      Divider(),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("post")
                              .where("uid",
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: ((context, snapshot) {
                            return GridView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 1.5,
                                      childAspectRatio: 1),
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    snapshot.data!.docs[index];
                                return Container(
                                    child: Image(
                                  image: NetworkImage(
                                    (snap.data() as dynamic)["postUrl"],
                                  ),
                                  fit: BoxFit.cover,
                                ));
                              },
                            );
                          }))
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
