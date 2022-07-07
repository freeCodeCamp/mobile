import 'dart:convert';

import 'package:flutter_code_editor/controller/editor_view_controller.dart';
import 'package:flutter_code_editor/models/file_model.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class ChallengeModel extends BaseViewModel {
  String? _editorText;
  String? get editorText => _editorText;

  bool _showPreview = false;
  bool get showPreview => _showPreview;

  final bool _hideAppBar = false;
  bool get hideAppBar => _hideAppBar;

  WebViewController? _webviewController;
  WebViewController? get webviewController => _webviewController;

  set setWebviewController(WebViewController value) {
    _webviewController = value;
    notifyListeners();
  }

  set showPreview(bool value) {
    _showPreview = value;
    notifyListeners();
  }

  Future<Challenge?> initChallenge(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(url) == null) {
      http.Response res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        prefs.setString(url, res.body);

        dev.log('challenge cache got add on: $url');

        return Challenge.fromJson(jsonDecode(res.body)['result']['data']
            ['challengeNode']['challenge']);
      }
    } else {
      return Challenge.fromJson(
          jsonDecode(prefs.getString(url) as String)['result']['data']
              ['challengeNode']['challenge']);
    }

    return null;
  }

  Future disposeCahce(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(url) != null) {
      prefs.remove(url);
      dev.log('challenge cache got disposed');
    }

    EditorViewController controller = EditorViewController();

    controller.removeAllRecentlyOpenedFilesCache('');
  }

  List<FileIDE> returnFiles(Challenge challenge) {
    List<FileIDE> files = [];

    for (ChallengeFile file in challenge.files) {
      files.add(FileIDE(
          fileName: file.name,
          filePath: '',
          fileContent: file.contents,
          parentDirectory: '',
          fileExplorer: null));
    }

    return files;
  }

  void updateText(String newText) {
    _editorText = newText;
    notifyListeners();
  }
}
