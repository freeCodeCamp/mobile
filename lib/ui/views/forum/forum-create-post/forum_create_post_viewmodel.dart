import 'package:flutter/cupertino.dart';
import 'package:freecodecamp/ui/views/forum/forum_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class ForumCreatePostModel extends BaseViewModel {
  final _title = TextEditingController();
  final _code = TextEditingController();

  TextEditingController get title => _title;
  TextEditingController get code => _code;

  Future<void> createPost(String title, String text, [int? categoryId]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      'X-Requested-With': 'XMLHttpRequest',
      "Content-Type": 'application/x-www-form-urlencoded'
    };

    ForumConnect.connectAndPost('/posts.json?title=$title&raw=$text', headers);
  }
}
