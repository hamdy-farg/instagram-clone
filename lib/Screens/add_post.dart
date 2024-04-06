import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/model/model_user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/Colors.dart';
import 'package:instagram_clone/utils/Utils.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isLouding = false;
  Uint8List? _file;
  TextEditingController? _textEditingController;
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await Pickimage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("open galery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await Pickimage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text("close"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  addpost() {}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
  }

  void clearImge() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    print(user.photourl);
    return _file == null
        ? Center(
            child: IconButton(
              icon: Icon(Icons.upload),
              onPressed: () {
                _selectImage(context);
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgournd,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  clearImge();
                },
              ),
              title: Text("Post to"),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          isLouding = true;
                        });
                        String res = await FireStoreMethods().uploudImage(
                            _file!,
                            _textEditingController!.text,
                            FirebaseAuth.instance.currentUser!.uid,
                            user.username,
                            user.photourl);
                        if (res.contains("successful")) {
                          clearImge();
                          showSnackBar("Posted", context);
                          setState(() {
                            isLouding = false;
                          });
                        } else {
                          showSnackBar(res, context);
                          setState(() {
                            isLouding = false;
                          });
                        }
                      } catch (e) {
                        showSnackBar(e.toString(), context);
                        setState(() {
                          isLouding = false;
                        });
                      }
                    },
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
              ],
            ),
            body: Column(
              children: [
                isLouding
                    ? LinearProgressIndicator()
                    : Padding(padding: EdgeInsets.only(top: 0)),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(user.photourl)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                            hintText: "Write a caption",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter)),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider()
              ],
            ),
          );
  }
}
