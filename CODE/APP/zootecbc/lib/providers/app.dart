import 'package:flutter/material.dart';
import 'package:zootecbc/models/app_preferences.dart';
import 'package:zootecbc/models/user.dart';

class AppProvider with ChangeNotifier {
  UserModel _user = UserModel(roles: []);

  dynamic _config = null;
  UserModel get user => _user;

  setConfig(dynamic config) {
    _config = config;
    notifyListeners();
  }

  setUser(UserModel user) async {
    _user = user;
    await AppPreferences().setUser(user);
    notifyListeners();
  }
}
