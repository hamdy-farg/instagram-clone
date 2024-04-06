import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Screens/Signup_Screen.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/utils/Colors.dart';
import 'package:instagram_clone/utils/CustomTextField.dart';
import 'package:instagram_clone/utils/Utils.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> SignupFormKey = GlobalKey();
  String result = "3";
  bool flag = false;
  bool secure = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  Uint8List? _file;
  bool circul = false;

  @override
  Widget build(BuildContext context) {
    dispose() {
      _emailController.dispose();
      _passwordController.dispose();
      _usernameController.dispose();
      _bioController.dispose();
    }

    selectedImage() async {
      Uint8List im = await Pickimage(ImageSource.gallery);
      setState(() {
        _file = im;
      });
      setState(() {});
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: double.infinity,
          child: Form(
            key: SignupFormKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(),
                    flex: 1,
                  ),
                  SvgPicture.asset(
                    "assets/ic_instagram (1).svg",
                    color: primaryColor,
                  ),
                  SizedBox(
                    height: 64,
                  ),
                  Stack(
                    children: [
                      _file == null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  "https://images.unsplash.com/photo-1511367461989-f85a21fda167?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D"),
                            )
                          : CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_file!),
                            ),
                      Positioned(
                        child: IconButton(
                            onPressed: () {
                              selectedImage();
                            },
                            icon: Icon(Icons.add_a_photo)),
                        right: 10,
                        bottom: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  CustomTextField(
                    textEditingController: _usernameController,
                    hintText: "Enter your user name",
                    validator: (val) {
                      if (val!.isEmpty) {
                        return ("please Enter your user name");
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  CustomTextField(
                    textEditingController: _emailController,
                    hintText: "Enter your email",
                    validator: (val) {
                      if (val!.isEmpty) {
                        return ("please Enter your email");
                      } else if (result
                          .contains("email address is badly formatted")) {
                        result = "";
                        return "please Enter valid email address";
                      } else if (result.contains(
                          "address is already in use by another account")) {
                        result = "";
                        return ("the email is already in use");
                      } else if (result.contains("email not verfied")) {
                        result = "";
                        final SnackBar snackBar = SnackBar(
                            content: Text(
                                "please check your email for verfication link"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return ("email not veryfied");
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  CustomTextField(
                      hintText: "Enter your password",
                      validator: (val) {
                        if (val!.isEmpty) {
                          return ("please Enter your password");
                        } else if (result.contains("at least 6")) {
                          result = "";
                          return " the password must be larger than 6 characters";
                        }
                      },
                      keyboardType: TextInputType.visiblePassword,
                      secure: secure,
                      textEditingController: _passwordController,
                      icon: flag
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  flag = false;
                                  secure = true;
                                });
                              },
                              icon: Icon(Icons.remove_red_eye_outlined))
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  flag = true;
                                  secure = false;
                                });
                              },
                              icon: Icon(Icons.remove_red_eye))),
                  SizedBox(
                    height: 24,
                  ),
                  CustomTextField(
                    textEditingController: _bioController,
                    hintText: "Enter your bio",
                    validator: (val) {
                      if (val!.isEmpty) {
                        return ("please Enter your bio");
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: () async {
                      if (SignupFormKey.currentState!.validate()) {
                        circul = true;
                        setState(() {});
                        result = await Methods().signupUser(
                            context: context,
                            email: _emailController.text,
                            password: _passwordController.text,
                            username: _usernameController.text,
                            bio: _bioController.text,
                            file: _file!);
                        setState(() {
                          circul = false;
                          SignupFormKey.currentState!.validate();
                        });
                      }
                    },
                    child: Container(
                      child: circul
                          ? CircularProgressIndicator()
                          : Text("Sign up"),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      width: double.infinity,
                      decoration: ShapeDecoration(
                          color: blueColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)))),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Flexible(
                    child: Container(),
                    flex: 2,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
