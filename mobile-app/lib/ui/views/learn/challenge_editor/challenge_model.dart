import 'dart:convert';

import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class ChallengeModel extends BaseViewModel {
  Future<Challenge?> initChallenge(String url) async {
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      return Challenge.fromJson(
          jsonDecode(res.body)['result']['data']['challengeNode']['challenge']);
    }

    return null;
  }

  String challengeTestToJs(List<ChallengeTest> test) {
    List<String> js = [];

    for (int i = 0; i < test.length; i++) {
      js.add('${test[i].javaScript.replaceAll(";", "")}');
    }

    return js.join('');
  }
}
