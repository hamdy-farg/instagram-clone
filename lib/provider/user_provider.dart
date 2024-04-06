import "package:flutter/material.dart";
import "package:instagram_clone/model/model_user.dart";
import "package:instagram_clone/resources/auth_methods.dart";

class UserProvider with ChangeNotifier {
  User? _user;
  User get getUser => _user!;
  refreshUser() async {
    User user = await Methods().getUserDetails();
    _user = user;
    notifyListeners();
  }
}
