import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/model/model_user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

class CommentCard extends StatefulWidget {
  final snap;
  String postId;
  CommentCard({super.key, this.snap, required this.postId});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    String date = formatDate(
        widget.snap["datePublished"].toDate(), [M, " ", dd, ", ", yyyy]);
    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap["profilePic"]),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${widget.snap["name"]}   ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    TextSpan(
                        text: widget.snap["text"],
                        style: TextStyle(color: Colors.white))
                  ])),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(date),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              FireStoreMethods().likeComment(widget.postId,
                  widget.snap["commentId"], user.uid, widget.snap["likes"]);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: widget.snap["likes"].contains(user.uid)
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_outline),
            ),
          ),
          Text(widget.snap["likes"].length.toString())
        ],
      ),
    );
  }
}
