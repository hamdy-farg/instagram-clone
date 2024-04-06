import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/utils/Colors.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:provider/provider.dart';
import "package:instagram_clone/model/model_user.dart" as model;

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen>  {
  int _page = 0;
  late PageController pageController;
  initState() {
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    model.User user =   Provider.of<UserProvider>(context).getUser;

    print(user.email);
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: OnPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
              label: "",
              backgroundColor: mobileBackgournd),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: _page == 1 ? primaryColor : secondaryColor),
              label: "",
              backgroundColor: mobileBackgournd),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle,
                  color: _page == 2 ? primaryColor : secondaryColor),
              label: "",
              backgroundColor: mobileBackgournd),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite,
                  color: _page == 3 ? primaryColor : secondaryColor),
              label: "",
              backgroundColor: mobileBackgournd),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _page == 4 ? primaryColor : secondaryColor),
              label: "",
              backgroundColor: mobileBackgournd)
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
