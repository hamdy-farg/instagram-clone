import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/Screens/profile_screen.dart';
import 'package:instagram_clone/utils/Colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/utils/global_variable.dart'; //import libray

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgournd,
        title: TextFormField(
          controller: _searchController,
          validator: (value) {
            if (value!.isEmpty) return ("field can not be empyt");
          },
          decoration: InputDecoration(labelText: "Search for a user"),
          onFieldSubmitted: (String _) {
            print(_);
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("Userdata")
                  .where("username", isEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  print(snapshot.data!.docs.length);
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    uid: snapshot.data!.docs[index]["uid"])));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(snapshot
                                  .data!.docs[index]["photourl"]
                                  .toString()),
                            ),
                            title: Text(snapshot.data!.docs[index]["username"]),
                          ),
                        );
                      });
                }
                return Text(snapshot.hasData.toString());
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("post")
                  .where("postUrl", isNull: false)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      snapshot.data!.docs[index]["postUrl"],
                      fit: BoxFit.cover,
                    );
                  },
                  staggeredTileBuilder: (index) =>
                      MediaQuery.of(context).size.width > webSreenSize
                          ? StaggeredTile.count(
                              index % 7 == 0 ? 1 : 1, index % 7 == 0 ? 1 : 1)
                          : StaggeredTile.count(
                              index % 7 == 0 ? 2 : 1, index % 7 == 0 ? 2 : 1),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                );
              }),
    );
  }
}
