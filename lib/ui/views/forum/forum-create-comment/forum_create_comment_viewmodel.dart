import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:freecodecamp/models/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum_connect.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class ForumCreateCommentViewModel extends BaseViewModel {
  final _commentText = TextEditingController();

  bool _hasError = false;
  bool get commentHasError => _hasError;

  String _errorMessage = '';
  String get errorMesssage => _errorMessage;

  TextEditingController get commentText => _commentText;

  Future<void> createComment(
      String topicId, String text, PostModel topic) async {
    Map<String, String> headers = {
      'X-Requested-With': 'XMLHttpRequest',
      "Content-Type": 'application/x-www-form-urlencoded'
    };

    final response = await ForumConnect.connectAndPost(
        '/posts.json?&topic_id=$topicId&raw=$text', headers);

    if (response.statusCode == 200) {
      _commentText.text = '';
      notifyListeners();
    } else {
      Map<String, dynamic> body = json.decode(response.body);

      if (body.containsKey("errors")) {
        _hasError = true;
        _errorMessage = body["errors"][0];
        notifyListeners();
      }
      dev.log(response.body);
    }
  }
}
