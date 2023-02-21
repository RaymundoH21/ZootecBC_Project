import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zootecbc/models/user.dart';

class AppPreferences {
  static const USER = "user";
  setUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER, jsonEncode(UserModel(roles: []).toJson(user)));
  }

  Future<UserModel> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userString = prefs.getString(USER) ?? null;

    if (userString != null && userString != "") {
      var tmp = UserModel.fromJson(jsonDecode(userString));
      return tmp;
    } else {
      return UserModel(roles: []);
    }
  }
}
