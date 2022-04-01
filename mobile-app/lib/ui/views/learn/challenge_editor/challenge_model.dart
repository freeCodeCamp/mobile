import 'dart:convert';

import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class ChallengeModel extends BaseViewModel {
  String? _editorText;
  String? get editorText => _editorText;

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
  }

  void updateText(String newText) {
    _editorText = newText;
    notifyListeners();
  }
}
