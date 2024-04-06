import "dart:html";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:instagram_clone/Screens/commentScreen.dart";
import "package:instagram_clone/model/model_user.dart";
import "package:instagram_clone/provider/user_provider.dart";
import "package:instagram_clone/resources/firestore_methods.dart";
import "package:instagram_clone/utils/Colors.dart";
import "package:instagram_clone/utils/Utils.dart";
import "package:instagram_clone/utils/global_variable.dart";
import "package:instagram_clone/utils/likes_animation.dart";
import "package:provider/provider.dart";

class PostCard extends StatefulWidget {
  final snap;
  PostCard({required this.snap, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool deleted = false;
  bool isLikeAnimating = false;
  int? commentLen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("post")
          .doc(widget.snap["postId"])
          .collection("comments")
          .get();
      commentLen = snap.docs.length;
      setState(() {});
      return snap;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      decoration: BoxDecoration(
          color: mobileBackgournd,
          border: Border.all(
              color: width > webSreenSize ? secondaryColor : mobileBackgournd)),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(widget.snap["profileImage"])),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap["username"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: ListView(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: ["Delete"]
                                      .map((e) => InkWell(
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              String res =
                                                  await FireStoreMethods()
                                                      .deletPost(widget
                                                          .snap["postId"]);
                                              print(res);
                                              if (res.contains("successful")) {}
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ));
                    },
                    icon: Icon(Icons.more_vert))
              ],
            ),
            // IMAGE SECTION
          ),
          GestureDetector(
            onDoubleTap: () {
              FireStoreMethods().likePost(
                  widget.snap["postId"], user.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap["postUrl"],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimaiton(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),

          // Like Comment Section
          Row(
            children: [
              LikeAnimaiton(
                isAnimating: widget.snap["likes"].contains(user.uid),
                smallike: true,
                child: IconButton(
                    onPressed: () {
                      FireStoreMethods().likePost(widget.snap["postId"],
                          user.uid, widget.snap['likes']);
                    },
                    icon: widget.snap["likes"].contains(user.uid)
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(Icons.favorite_border_outlined)),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentScreen(snap: widget.snap)));
                },
                icon: Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.bookmark_border),
                ),
              ))
            ],
          ),
          // DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    "${widget.snap["likes"].length} likes",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                              text: widget.snap["username"],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: "  ${widget.snap["discription"]}",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    child: Text(
                      "View all ${commentLen} comments",
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    widget.snap["datePublished"],
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
