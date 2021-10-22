import 'package:flutter/cupertino.dart';
import 'package:freecodecamp/ui/views/forum/forum_connect.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class ForumCreateCommentViewModel extends BaseViewModel {
  final _commentText = TextEditingController();

  TextEditingController get commentText => _commentText;

  Future<void> createComment(String topicId, String text) async {
    Map<String, String> headers = {
      'X-Requested-With': 'XMLHttpRequest',
      "Content-Type": 'application/x-www-form-urlencoded'
    };
    dev.log('i got called');
    final response = await ForumConnect.connectAndPost(
        '/posts.json?&topic_id=$topicId&raw=$text', headers);

    if (response.statusCode == 200) {
      _commentText.text = '';
      notifyListeners();
    } else {
      dev.log(response.body);
    }
  }
}
