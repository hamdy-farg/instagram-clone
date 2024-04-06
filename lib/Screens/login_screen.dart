import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/Screens/Signup_Screen.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/utils/Colors.dart';
import 'package:instagram_clone/utils/CustomTextField.dart';
import 'package:instagram_clone/utils/global_variable.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool flag = false;
  bool secure = true;
  String? result = "def";
  void login() async {
    if (loginFormKey.currentState!.validate()) {
      circul = true;
      setState(() {});
      result = await Methods().loginUser(
          email: _emailController.text,
          password: _passwordController.text,
          context: context);
    }

    setState(() {
      loginFormKey.currentState!.validate();
      circul = false;
    });
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey();
  bool? circul = false;
  @override
  Widget build(BuildContext context) {
    dispose() {
      _emailController.dispose();
      _passwordController.dispose();
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webSreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Form(
            key: loginFormKey,
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
                  CustomTextField(
                    textEditingController: _emailController,
                    hintText: "Enter your email",
                    validator: (val) {
                      if (val!.isEmpty) {
                        return ("please Enter your email");
                      } else if (result!
                          .contains("email address is badly formatted")) {
                        result = "";
                        return "please Enter valid email address";
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
                        } else if (result!.contains(
                            "The supplied auth credential is incorrect")) {
                          result = "";
                          return "the password is incorrect . ";
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("do you forget your password ?"),
                      TextButton(
                          onPressed: () async {
                            result = await Methods()
                                .passwordResset(email: _emailController.text);
                            print(result);
                            if (result!.contains(
                                "password reset was sent to your email")) {
                              SnackBar snackBar = SnackBar(
                                  content: Text(
                                      "password reset was sent to your email"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }

                            setState(() {});
                          },
                          child: Text("reset"))
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      login();
                    },
                    child: Container(
                      child: circul!
                          ? CircularProgressIndicator()
                          : Text("Log in"),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("don't have account ? "),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
