import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/forum_user_model.dart';
import 'package:freecodecamp/ui/views/forum/forum_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class ForumUserProfileViewModel extends BaseViewModel {
  late User _user;
  User get user => _user;

  late String _username;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  bool _userLoaded = false;
  bool get userLoaded => _userLoaded;

  void initState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') as String;
    _username = username;
    _user = await fetchUser(username);
    notifyListeners();
  }

  Future<User> fetchUser(String? username) async {
    final response = await ForumConnect.connectAndGet('/u/$username');

    if (response.statusCode == 200) {
      dev.log(response.body.toString());
      _userLoaded = true;
      notifyListeners();
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception('could not load user data: ' + response.body.toString());
  }

  Future<void> changeEmail() async {}
}
