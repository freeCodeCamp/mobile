import 'dart:convert';

import 'package:flutter_code_editor/controller/editor_view_controller.dart';
import 'package:flutter_code_editor/models/file_model.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
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

  bool _hideAppBar = false;
  bool get hideAppBar => _hideAppBar;

  bool _showDescription = false;
  bool get showDescription => _showDescription;

  WebViewController? _webviewController;
  WebViewController? get webviewController => _webviewController;

  set setHideAppBar(bool value) {
    _hideAppBar = value;
    notifyListeners();
  }

  set setShowDescription(bool value) {
    _showDescription = value;
    notifyListeners();
  }

  set setWebviewController(WebViewController value) {
    _webviewController = value;
    notifyListeners();
  }

  set showPreview(bool value) {
    _showPreview = value;
    notifyListeners();
  }

  set setEditorText(String? value) {
    _editorText = value;
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

  String parsePreviewDocument(String docString) {
    Document document = parse(docString);

    String viewPort =
        '<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport"></meta>';

    Document viewPortParsed = parse(viewPort);
    Node meta = viewPortParsed.getElementsByTagName('META')[0];

    document.getElementsByTagName('HEAD')[0].append(meta);

    dev.log(document.outerHtml);

    return document.outerHtml;
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
