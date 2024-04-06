import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Screens/Signup_Screen.dart';
import 'package:instagram_clone/Screens/login_screen.dart';
import 'package:instagram_clone/model/model_user.dart' as Users;
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/responsive/mobileScreen.dart';
import 'package:instagram_clone/responsive/responsive_layout_Screen.dart';
import 'package:instagram_clone/responsive/webScreen.dart';
import 'package:instagram_clone/utils/Colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDvRdRE6XlCSDi1t8CdPvk__pGwT3gIp0s",
            authDomain: "instagram-clone2-33b67.firebaseapp.com",
            projectId: "instagram-clone2-33b67",
            storageBucket: "instagram-clone2-33b67.appspot.com",
            messagingSenderId: "984994569613",
            appId: "1:984994569613:web:15dc30427f33f92e2031c4"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Instagram Clone",
          theme: ThemeData.dark()
              .copyWith(),
          home: 
       StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ResponsiveLayout(
                      MobileScreen: MobileScreen(), WebScreen: WebScreen());
                }
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.hasError}"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: primaryColor,
                ));
              }
              return LoginScreen();
            },
          )),
          
    );
  }
}
