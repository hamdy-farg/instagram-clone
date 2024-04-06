import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/responsive/mobileScreen.dart';
import 'package:instagram_clone/utils/Colors.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:provider/provider.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

String? username = "";

class _WebScreenState extends State<WebScreen> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    getUserName();
    super.initState();
    pageController = PageController();
  }

  dispose() {
    pageController.dispose();
  }

  OnPageChanged(int page) {
    _page = page;
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  getUserName() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
          .instance
          .collection("Userdata")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      setState(() {
        username = (snap.data() as Map<String, dynamic>)["username"];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: width > webSreenSize ? webBackgroundColor: mobileBackgournd,
        appBar: AppBar(
          backgroundColor:width > webSreenSize ? webBackgroundColor: mobileBackgournd,
          centerTitle: false,
          title: SvgPicture.asset(
            "assets/ic_instagram (1).svg",
            color: primaryColor,
            height: 32,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  navigationTapped(0);
                },
                icon: Icon(Icons.home),
                color: _page == 0 ? primaryColor : secondaryColor),
            IconButton(
                onPressed: () {
                  navigationTapped(1);
                },
                icon: Icon(Icons.search),
                color: _page == 1 ? primaryColor : secondaryColor),
            IconButton(
                onPressed: () {
                  navigationTapped(2);
                },
                icon: Icon(Icons.favorite),
                color: _page == 2 ? primaryColor : secondaryColor),
            IconButton(
                onPressed: () {
                  navigationTapped(3);
                },
                icon: Icon(Icons.add_photo_alternate),
                color: _page == 3 ? primaryColor : secondaryColor),
            IconButton(
                onPressed: () {
                  navigationTapped(4);
                },
                icon: Icon(Icons.person),
                color: _page == 4 ? primaryColor : secondaryColor),
          ],
        ),
        body: PageView(
        
          controller: pageController,
          onPageChanged: OnPageChanged,
          children: homeScreenItems,
          physics: NeverScrollableScrollPhysics(),
        ));
  }
}
