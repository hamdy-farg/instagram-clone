import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget WebScreen;
  final Widget MobileScreen;
  ResponsiveLayout(
      {super.key, required this.MobileScreen, required this.WebScreen});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  var snap;
  bool isLouding = true;
  int postLen = 0;
  @override
  void initState() {
    addData();
    // TODO: implement initState
    super.initState();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();

    setState(() {
      isLouding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (constraints.maxWidth > webSreenSize) {
        return (widget.WebScreen);
      }
      return isLouding
          ? Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : (widget.MobileScreen);
    }));
  }
}
